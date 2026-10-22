-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99A/s21p0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_H01P99A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="So, basically...[K] [CS:N]Lapras[CR] didn't\nknow much about the distortion of space.", french="En gros...[K] [CS:N]Lokhlass[CR] ne savait\nrien sur la distorsion de l'espace.", german="Also, eigentlich[K] wusste [CS:N]Lapras[CR]\nnicht viel über die Verzerrung des Raumes.", italian="Quindi...[K] [CS:N]Lapras[CR] non sapeva\nmolto a proposito della distorsione dello\nspazio.", spanish="En realidad...[K] [CS:N]Lapras[CR] no sabía\nmucho de la deformación del espacio."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="So, basically...[K] [CS:N]Lapras[CR] didn't\nknow much about the distortion of space.", french="En gros...[K] [CS:N]Lokhlass[CR] ne savait\nrien sur la distorsion de l'espace.", german="Also, eigentlich[K] wusste [CS:N]Lapras[CR]\nnicht viel über die Verzerrung des Raumes.", italian="Quindi...[K] [CS:N]Lapras[CR] non sapeva\nmolto a proposito della distorsione dello\nspazio.", spanish="En realidad...[K] [CS:N]Lapras[CR] no sabía\nmucho de la deformación del espacio."})
  else
  SkySceneKit.say({english="So, basically...[K] [CS:N]Lapras[CR] didn't\nknow much about the distortion of space.", french="En gros...[K] [CS:N]Lokhlass[CR] ne savait\nrien sur la distorsion de l'espace.", german="Also, eigentlich[K] wusste [CS:N]Lapras[CR]\nnicht viel über die Verzerrung des Raumes.", italian="Quindi...[K] [CS:N]Lapras[CR] non sapeva\nmolto a proposito della distorsione dello\nspazio.", spanish="En realidad...[K] [CS:N]Lapras[CR] no sabía\nmucho de la deformación del espacio."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But he did tell us that [CS:N]Palkia[CR]\ncontrols space itself...[K] And that this being\ndwells in [CS:P]Spacial Rift[CR].", french="Mais il nous a appris que [CS:N]Palkia[CR]\ncontrôle l'espace...[K] et qu'il réside\ndans la [CS:P]Faille Spatiale[CR].", german="Aber von ihm wissen wir, dass\n[CS:N]Palkia[CR] den Raum selbst kontrolliert...[K] Und dass\ndieses Wesen in der [CS:P]Raumspalte[CR] wohnt.", italian="Però ci ha detto che [CS:N]Palkia[CR]\ncontrolla lo spazio.[K] E che questo essere si\ntrova nella [CS:P]Valle Dimensionale[CR].", spanish="Pero nos dijo que [CS:N]Palkia[CR]\nlo controla.[K] Y que este ser habita en la\n[CS:P]Grieta Espacial[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But he did tell us that [CS:N]Palkia[CR]\ncontrols space itself...[K] And that this being\ndwells in [CS:P]Spacial Rift[CR].", french="Mais il nous a appris que [CS:N]Palkia[CR]\ncontrôle l'espace...[K] et qu'il réside\ndans la [CS:P]Faille Spatiale[CR].", german="Aber von ihm wissen wir, dass\n[CS:N]Palkia[CR] den Raum selbst kontrolliert...[K] Und dass\ndieses Wesen in der [CS:P]Raumspalte[CR] wohnt.", italian="Però ci ha detto che [CS:N]Palkia[CR]\ncontrolla lo spazio.[K] E che questo essere si\ntrova nella [CS:P]Valle Dimensionale[CR].", spanish="Pero nos dijo que [CS:N]Palkia[CR]\nlo controla.[K] Y que este ser habita en la\n[CS:P]Grieta Espacial[CR]."})
  else
  SkySceneKit.say({english="But he did tell us that [CS:N]Palkia[CR]\ncontrols space itself...[K] And that this being\ndwells in [CS:P]Spacial Rift[CR].", french="Mais il nous a appris que [CS:N]Palkia[CR]\ncontrôle l'espace...[K] et qu'il réside\ndans la [CS:P]Faille Spatiale[CR].", german="Aber von ihm wissen wir, dass\n[CS:N]Palkia[CR] den Raum selbst kontrolliert...[K] Und dass\ndieses Wesen in der [CS:P]Raumspalte[CR] wohnt.", italian="Però ci ha detto che [CS:N]Palkia[CR]\ncontrolla lo spazio.[K] E che questo essere si\ntrova nella [CS:P]Valle Dimensionale[CR].", spanish="Pero nos dijo que [CS:N]Palkia[CR]\nlo controla.[K] Y que este ser habita en la\n[CS:P]Grieta Espacial[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Palkia[CR], huh...", french=" [CS:N]Palkia[CR]...", german=" [CS:N]Palkia[CR], was?", italian=" [CS:N]Palkia[CR]...", spanish=" [CS:N]Palkia[CR], eh..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Palkia[CR], huh...", french=" [CS:N]Palkia[CR]...", german=" [CS:N]Palkia[CR], was?", italian=" [CS:N]Palkia[CR]...", spanish=" [CS:N]Palkia[CR], eh..."})
  else
  SkySceneKit.say({english=" [CS:N]Palkia[CR], huh...", french=" [CS:N]Palkia[CR]...", german=" [CS:N]Palkia[CR], was?", italian=" [CS:N]Palkia[CR]...", spanish=" [CS:N]Palkia[CR], eh..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If we can meet with [CS:N]Palkia[CR],\nwe'd be able to ask about the distortion\nof space.", french="Si seulement on avait l'occasion\nde rencontrer [CS:N]Palkia[CR], on pourrait\nle questionner sur la distorsion de l'espace.", german="Wenn wir [CS:N]Palkia[CR] finden, können\nwir es auch über die Raumverzerrung\nbefragen.", italian="Se riuscissimo a trovare [CS:N]Palkia[CR],\npotremmo chiedergli cosa sa della\ndistorsione dello spazio.", spanish="Si logramos encontrar a [CS:N]Palkia[CR],\npodremos preguntarle sobre la deformación\ndel espacio."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If we can meet with [CS:N]Palkia[CR],\nwe'd be able to ask about the distortion\nof space.", french="Si seulement on avait l'occasion\nde rencontrer [CS:N]Palkia[CR], on pourrait\nle questionner sur la distorsion de l'espace.", german="Wenn wir [CS:N]Palkia[CR] finden, können\nwir es auch über die Raumverzerrung\nbefragen.", italian="Se riuscissimo a trovare [CS:N]Palkia[CR],\npotremmo chiedergli cosa sa della\ndistorsione dello spazio.", spanish="Si logramos encontrar a [CS:N]Palkia[CR],\npodremos preguntarle sobre la deformación\ndel espacio."})
  else
  SkySceneKit.say({english="If we can meet with [CS:N]Palkia[CR],\nwe'd be able to ask about the distortion\nof space.", french="Si seulement on avait l'occasion\nde rencontrer [CS:N]Palkia[CR], on pourrait\nle questionner sur la distorsion de l'espace.", german="Wenn wir [CS:N]Palkia[CR] finden, können\nwir es auch über die Raumverzerrung\nbefragen.", italian="Se riuscissimo a trovare [CS:N]Palkia[CR],\npotremmo chiedergli cosa sa della\ndistorsione dello spazio.", spanish="Si logramos encontrar a [CS:N]Palkia[CR],\npodremos preguntarle sobre la deformación\ndel espacio."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But we don't know where\n[CS:P]Spacial Rift[CR] is...", french="Mais on n'a aucune idée sur\nl'emplacement de la [CS:P]Faille Spatiale[CR]...", german="Aber wir wissen nicht, wo die\n[CS:P]Raumspalte[CR] ist...", italian="Ma non sappiamo dove si trova\nla [CS:P]Valle Dimensionale[CR]...", spanish="Pero no sabemos dónde está la\n[CS:P]Grieta Espacial[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But we don't have a clue as to\nwhere [CS:P]Spacial Rift[CR] is...", french="Mais on n'a aucune idée sur\nl'emplacement de la [CS:P]Faille Spatiale[CR]...", german="Aber wir haben keinen\nAnhaltspunkt, wo die [CS:P]Raumspalte[CR] sein kann...", italian="Ma non sappiamo dove si trova\nla [CS:P]Valle Dimensionale[CR]...", spanish="Pero no sabemos dónde está la\n[CS:P]Grieta Espacial[CR]..."})
  else
  SkySceneKit.say({english="But we don't know where\n[CS:P]Spacial Rift[CR] is...", french="Mais on n'a aucune idée sur\nl'emplacement de la [CS:P]Faille Spatiale[CR]...", german="Aber wir wissen nicht, wo die\n[CS:P]Raumspalte[CR] ist...", italian="Ma non sappiamo dove si trova\nla [CS:P]Valle Dimensionale[CR]...", spanish="Pero no sabemos dónde está la\n[CS:P]Grieta Espacial[CR]..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hmm...[K] I guess there isn't any\npoint in worrying about it right now.", french="Hum...[K] Ça ne sert à rien de\ns'inquiéter pour le moment.", german="Hmm...[K] Das ist jetzt\nwohl noch kein Grund zur Sorge.", italian="Mmm...[K] È inutile\npreoccuparsene adesso.", spanish="Hum...[K] Preocuparse ahora de\neso no servirá de nada."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hmm...[K] I guess there isn't any\npoint in worrying about it right now.", french="Hum...[K] Ça ne sert à rien de\ns'inquiéter pour le moment.", german="Hmm...[K] Das ist jetzt\nwohl noch kein Grund zur Sorge.", italian="Mmm...[K] È inutile\npreoccuparsene adesso.", spanish="Hum...[K] Preocuparse ahora de\neso no servirá de nada."})
  else
  SkySceneKit.say({english="Hmm...[K] I guess there isn't any\npoint in worrying about it right now.", french="Hum...[K] Ça ne sert à rien de\ns'inquiéter pour le moment.", german="Hmm...[K] Das ist jetzt\nwohl noch kein Grund zur Sorge.", italian="Mmm...[K] È inutile\npreoccuparsene adesso.", spanish="Hum...[K] Preocuparse ahora de\neso no servirá de nada."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's continue to look into\nthis tomorrow.", french="On continuera nos recherches\ndemain.", german="Forschen wir morgen weiter\ndanach.", italian="Domani continueremo le nostre\nricerche.", spanish=" Sigamos investigando mañana."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's continue to investigate\nthis tomorrow.", french="On continuera nos recherches\ndemain.", german="Forschen wir morgen in der\nSache weiter.", italian="Domani continueremo le nostre\nricerche.", spanish=" Sigamos investigando mañana."})
  else
  SkySceneKit.say({english="Let's continue to look into\nthis tomorrow.", french="On continuera nos recherches\ndemain.", german="Forschen wir morgen weiter\ndanach.", italian="Domani continueremo le nostre\nricerche.", spanish=" Sigamos investigando mañana."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="There's no giving up now,\n[hero]!", french="Hors de question de perdre\ncourage, [hero]!", german="Aufgegeben wird nicht,\n[hero]!", italian="Non possiamo arrenderci ora,\n[hero]!", spanish="¡No podemos rendirnos ahora,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="There's no giving up now,\n[hero]!", french="Hors de question de perdre\ncourage, [hero]!", german="Aufgegeben wird nicht,\n[hero]!", italian="Non possiamo arrenderci ora,\n[hero]!", spanish="¡No podemos rendirnos ahora,\n[hero]!"})
  else
  SkySceneKit.say({english="There's no giving up now,\n[hero]!", french="Hors de question de perdre\ncourage, [hero]!", german="Aufgegeben wird nicht,\n[hero]!", italian="Non possiamo arrenderci ora,\n[hero]!", spanish="¡No podemos rendirnos ahora,\n[hero]!"})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
end
