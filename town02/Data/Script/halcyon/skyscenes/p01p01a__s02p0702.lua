-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/s02p0702.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 38) -- $SCENARIO_MAIN = scn[29,38] (ROM)
  -- back_SetGround(LEVEL_P01P03A) [neutre/état moteur]
  -- supervision_StationCommon(7) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  GAME:WaitFrames(30)
  local npc_npc_hassamu = SkySceneKit.spawn_npc("scizor", 216, 184, Direction.Down, "NPC_HASSAMU")
  pcall(function() UI:SetSpeaker(npc_npc_hassamu) end)
  SkySceneKit.say({english="I am sincerely grateful for your\ncoming to my rescue.", french="Je vous suis extrêmement\nreconnaissant d'avoir eu l'amabilité de\nme secourir.", german="Ich bin euch aufrichtig dankbar,\ndass ihr zu meiner Rettung gekommen seid.", italian="Vi sono molto grato per\navermi salvato.", spanish="Os estoy muy agradecido por\nvuestra ayuda."})
  pcall(function() UI:SetSpeaker(npc_npc_hassamu) end)
  SkySceneKit.say({english="If you hadn't come along, I very\nwell could have remained encased in ice\nforever.", french="Sans votre aide inopinée,\nj'aurais pu demeurer emprisonné\ndans ma geôle de glace pour l'éternité.", german="Wenn ihr nicht gekommen wärt,\nwäre ich wahrscheinlich ewig im Eis\neingeschlossen geblieben.", italian="Se non fosse stato per voi,\nprobabilmente sarei rimasto imprigionato nel\nghiaccio per l'eternità.", spanish="Si no hubierais venido, podría\nhaberme quedado encerrado en hielo\nde por vida."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_hassamu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_hassamu) end)
  SkySceneKit.say({english="However, little did I expect to\nsee that decades have passed since my\nicebound predicament.", french="Néanmoins, je ne m'attendais\nguère à demeurer ainsi figé plusieurs\ndizaines d'années durant.", german="Trotzdem hätte ich kaum\nerwartet, dass meine eisbedingte Unpässlich-\nkeit mehrere Jahrzehnte andauern würde.", italian="Tuttavia, non pensavo che\nfossero passati decenni da quando sono stato\ncatturato.", spanish="No tenía muchas esperanzas ya.\nLlevaba décadas atrapado en el hielo."})
  pcall(function() UI:SetSpeaker(npc_npc_hassamu) end)
  SkySceneKit.say({english="Why, it is as if I'd traveled to\nan entirely different world.", french="Allons bon, c'est comme si\nj'avais traversé les âges et étais parvenu\ndans un monde complètement différent.", german="Meine Güte, es ist, als wäre ich\nin eine völlig andere Welt gereist.", italian="È come se fossi stato in un\nmondo completamente diverso.", spanish="Es como si hubiera viajado a un\nmundo totalmente distinto."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_hassamu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_hassamu) end)
  SkySceneKit.say({english="Incidentally, I would like to\nsomehow repay you for saving my life.", french="A ce sujet, je souhaiterais\nardemment vous remercier pour m'avoir\nsauvé la vie.", german="Im Übrigen würde ich euch für\ndie Rettung meines Lebens gerne in irgendeiner\nForm entschädigen.", italian="Tra l'altro, vorrei ripagarvi in\nqualche modo per avermi salvato la vita.", spanish="Me gustaría compensaros de\nalgún modo por salvarme la vida."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_hassamu, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_hassamu) end)
  SkySceneKit.say({english="However, I find myself alone in\nan alien world, and without a single Poké to\nmy name.", french="En revanche, je suis désormais\nseul dans un monde qui m'est inconnu, et j'y\nai laissé jusqu'à mon dernier Poké.", german="Allerdings finde ich mich gerade\nin einer fremden Welt wieder, ohne einen\neinzigen Poké mein Eigen zu nennen.", italian="Purtroppo mi trovo da solo in un\nmondo estraneo, senza neanche un soldo\nin tasca.", spanish="Pero me hallo en un mundo\nextraño y sin un solo Poké encima."})
  pcall(function() UI:SetSpeaker(npc_npc_hassamu) end)
  SkySceneKit.say({english="I have but no idea how I could\npossibly repay you.", french="J'ignore totalement comment\nje puis vous remercier.", german="Mir fehlt es an einer Idee, wie\nich euch entschädigen könnte.", italian="Non so proprio come\nsdebitarmi.", spanish=" No sé cómo compensaros."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Oh, don't worry.[K] You don't need\nto thank us any more.", french="Oh, ne vous inquiétez pas.[K] Vous\nn'avez pas besoin de nous remercier.", german="Oh, keine Sorge.[K] Du brauchst\nuns nicht weiter zu danken.", italian="Oh, non preoccuparti.[K] Non devi\nringraziarci oltre.", spanish="Oh, no te preocupes.[K] No tienes\npor qué darnos más las gracias."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Oh, it's OK.[K] You don't need\nto thank us any more.", french="Oh, ne vous inquiétez pas.[K] Vous\nn'avez pas besoin de nous remercier.", german="Oh, keine Sorge.[K] Du brauchst\nuns nicht weiter zu danken.", italian="Oh, non preoccuparti.[K] Non devi\nringraziarci oltre.", spanish="Oh, no te preocupes.[K] No tienes\npor qué darnos más las gracias."})
  else
  SkySceneKit.say({english="Oh, don't worry.[K] You've already\nthanked us enough.", french="Oh, ne vous inquiétez pas.[K] Vous\nn'avez pas besoin de nous remercier.", german="Oh, keine Sorge.[K] Du brauchst\nuns nicht weiter zu danken.", italian="Oh, non preoccuparti.[K] Non devi\nringraziarci oltre.", spanish="Oh, no te preocupes.[K] No tienes\npor qué darnos más las gracias."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_hassamu) end)
  SkySceneKit.say({english=" Hmm... However...", french=" Hum... néanmoins...", german=" Hmm... Trotzdem...", italian=" Mmm... Tuttavia...", spanish=" Hum... Sin embargo..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8965) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_hassamu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_hassamu) end)
  SkySceneKit.say({english="Ah! Yes! That may do![K] Tell me,\nyou did say you were an exploration team, yes?", french="Ah, oui! Cela devrait vous\nseoir![K] Vous m'avez dit que vous étiez une\néquipe d'exploration, si je ne m'abuse?", german="Ah! Ja! Das könnte reichen![K]\nDu sagtest, ihr seid ein Erkundungsteam, ja?", italian="Ah! Sì! Potrebbe andare![K] Avete\ndetto di essere una squadra d'esplorazione,\ngiusto?", spanish="¡Ah, ya sé![K] Me dijisteis que\nsois un equipo explorador, ¿verdad?"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Uh...[K] Yup.", french=" Euh...[K] oui.", german=" Äh...[K] Jep.", italian=" Eh...[K] Sì.", spanish=" Eh...[K] Sí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Uh...[K] Yes.", french=" Euh...[K] oui.", german=" Öh...[K] Ja.", italian=" Eh...[K] Sì.", spanish=" Eh...[K] Sí."})
  else
  SkySceneKit.say({english=" Uh...[K] Yep.", french=" Euh...[K] oui.", german=" Öh...[K] Ja.", italian=" Eh...[K] Sì.", spanish=" Pues...[K] sí."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_hassamu) end)
  SkySceneKit.say({english="Ah, very well! You see, though\nyou may find it unlikely, I was once upon a\ntime an explorer of some repute.", french="A la bonne heure! Bien que vous\npuissiez trouver cela saugrenu, sachez que\nje fus autrefois un explorateur de renom.", german="Ah, sehr gut! Seht ihr, auch\nwenn es euch unwahrscheinlich erscheint, ich\nwar früher selbst Erkunder von einigem Rang.", italian="Ah, molto bene! Vedete, anche\nse potrà sembrarvi strano, una volta ero un\nesploratore abbastanza famoso.", spanish="¡Muy bien! Aunque os resulte\nextraño, yo también fui un explorador de\nrenombre en mis tiempos."})
  pcall(function() UI:SetSpeaker(npc_npc_hassamu) end)
  SkySceneKit.say({english="Well, I'll have you know...[K]\nI am an honorary member of the Pokémon\nExploration Team Federation!", french="Oui, apprenez que...[K]\nje suis membre honoraire de la Fédération\ndes Equipes d'Exploration!", german="Nun, ihr solltet wissen...[K]\nIch bin ein Ehrenmitglied des\nErkundungsteamverbands!", italian="Beh, voglio proprio dirvelo...[K]\nSono un membro onorario della Federazione\nSquadre d'Esplorazione!", spanish="De hecho, soy...[K] miembro\nhonorario de la Federación de Exploradores\nPokémon."})
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_hassamu, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_hassamu, "happy", 1) end)
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweatdrop", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" A what?[K] An honorary member?", french=" Quoi?[K] Un membre honoraire?", german=" Du bist was?[K] Ein Ehrenmitglied?", italian=" Cosa?[K] Un membro onorario?", spanish=" ¿Un qué?[K] ¿Miembro honorario?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" A what?[K] An honorary member?", french=" Quoi?[K] Un membre honoraire?", german=" Du bist was?[K] Ein Ehrenmitglied?", italian=" Cosa?[K] Un membro onorario?", spanish=" ¿Un qué?[K] ¿Miembro honorario?"})
  else
  SkySceneKit.say({english=" Pardon?[K] An honorary member?", french=" Quoi?[K] Un membre honoraire?", german=" Du bist was?[K] Ein Ehrenmitglied?", italian=" Cosa?[K] Un membro onorario?", spanish=" ¿Disculpa?[K] ¿Miembro honorario?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_hassamu, nil, 0) end) -- EFFECT_NONE
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_hassamu) end)
  SkySceneKit.say({english=" Correct!", french=" Précisément!", german=" Korrekt!", italian=" Esatto!", spanish=" ¡Exacto!"})
  pcall(function() UI:SetSpeaker(npc_npc_hassamu) end)
  SkySceneKit.say({english="An honorary member, such as\nmyself, has the right to give special status to\nexemplary exploration teams.", french="Les membres honoraires tels que\nmoi sont habilités à donner un statut spécial\naux équipes d'exploration exemplaires.", german="Ein Ehrenmitglied wie ich hat\ndas Recht, beispielhaften Erkundungsteams\neinen besonderen Status zu verleihen.", italian="Un membro onorario come me\nha il diritto di conferire uno stato speciale alle\nsquadre d'esplorazione più meritevoli.", spanish="Los miembros honorarios como\nyo tenemos derecho a dar un estado especial\na los equipos de exploración más ejemplares."})
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_hassamu) end)
  SkySceneKit.say({english="And you fit the bill! Your plucky\ncourage during my rescue proves that you are\nmore than exemplary!", french="Et vous êtes de celles-là! Votre\ncourage sans faille durant mon sauvetage\na sans nul doute démontré votre valeur!", german="Und ihr eignet euch sehr gut!\nEure beherzte Courage während meiner Rettung\nbelegt eure Beispielhaftigkeit eindrucksvoll!", italian="E voi lo siete sicuramente! Il\ncoraggio dimostrato venendo a salvarmi\ntestimonia che siete una squadra esemplare!", spanish="¡Así que hoy estáis de suerte!\n¡Vuestra gran valentía al rescatarme merece\nun premio!"})
  -- message_KeyWait
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_hassamu) end)
  SkySceneKit.say({english="So, I confer upon you...\nthe Secret Rank!", french="Alors, je vous octroie...\nle Grade Secret!", german="Deswegen verleihe ich euch...\nden Geheim-Rang!", italian="Pertanto, vi conferisco...\nil Rango Segreto!", spanish="Así que os confiero... ¡el Rango\nSecreto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?[K] Secret Rank?", french=" Quoi?[K] Le Grade Secret?", german=" Äh?[K] Geheim-Rang?", italian=" Eh?[K] Rango Segreto?", spanish=" ¿Qué?[K] ¿El Rango Secreto?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?[K] Secret Rank?", french=" Quoi?[K] Le Grade Secret?", german=" Was?[K] Geheim-Rang?", italian=" Cosa?[K] Rango Segreto?", spanish=" ¿Qué?[K] ¿El Rango Secreto?"})
  else
  SkySceneKit.say({english=" Pardon?[K] Secret Rank?", french=" Quoi?[K] Le Grade Secret?", german=" Wie bitte?[K] Geheim-Rang?", italian=" Cosa?[K] Rango Segreto?", spanish=" ¿Cómo?[K] ¿El Rango Secreto?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_hassamu) end)
  SkySceneKit.say({english="Yes. An exploration team with\nthat rank is eligible to take Special Missions.", french="Tout à fait. Seule une équipe\nd'exploration de ce grade peut effectuer\ndes Missions Spéciales.", german="Ja. Ein Erkundungsteam dieses\nRanges ist berechtigt, Spezialmissionen\ndurchzuführen.", italian="Sì. Una squadra d'esplorazione\ndi tale rango può accettare degli Incarichi\nSpeciali.", spanish="Sí. Con este rango podréis\naceptar misiones especiales."})
  pcall(function() UI:SetSpeaker(npc_npc_hassamu) end)
  SkySceneKit.say({english="Special Missions are highly\nconfidential jobs that come straight from the\nExploration Team Federation itself.", french="Les Missions Spéciales sont des\nmissions ultra-confidentielles qui proviennent\nde la Fédération des Equipes d'Exploration.", german="Spezialmissionen sind streng\nvertrauliche Erkundungsjobs, die direkt vom\nErkundungsteamverband vergeben werden.", italian="Sono missioni strettamente\nconfidenziali assegnate direttamente\ndalla Federazione Squadre d'Esplorazione.", spanish="Las misiones especiales son\ntareas confidenciales que provienen\ndirectamente de la Federación de Exploradores."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Highly confidential?[K]\nWhy all the secrecy?", french="Ultra-confidentielles?[K]\nPourquoi toutes ces précautions?", german="Streng vertraulich?[K]\nWozu die ganze Geheimnistuerei?", italian="Strettamente confidenziali?[K]\nPerché mai tutta questa segretezza?", spanish="¿Confidenciales?[K]\n¿Y por qué tanto secretismo?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Highly confidential?[K]\nI don't get it...", french="Ultra-confidentielles?[K]\nPourquoi toutes ces précautions?", german="Streng vertraulich?[K]\nVersteh ich nicht...", italian="Strettamente confidenziali?[K]\nMi sfugge qualcosa...", spanish="¿Confidenciales?[K]\nNo lo pillo..."})
  else
  SkySceneKit.say({english="Highly confidential?[K]\nI don't understand...", french="Ultra-confidentielles?[K]\nPourquoi toutes ces précautions?", german="Streng vertraulich?[K]\nWie bitte?", italian="Strettamente confidenziali?[K]\nNon capisco...", spanish="¿Confidenciales?[K]\nNo lo entiendo..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_hassamu) end)
  SkySceneKit.say({english="You may not know now. But it\nwill become clear in due time.", french="Vous ne le saurez pas\naujourd'hui, mais tout deviendra\nclair en temps voulu.", german="Ihr mögt es jetzt noch nicht\nwissen, aber das werdet ihr zu gegebener Zeit\nschon noch.", italian="Adesso non lo sapete. Ma più\navanti diventerà tutto più chiaro.", spanish="No os preocupéis, lo entenderéis\na su debido tiempo."})
  pcall(function() UI:SetSpeaker(npc_npc_hassamu) end)
  SkySceneKit.say({english="I'll need to make a note of your\nnew rank on your Explorer Badge.", french="Je dois ajouter votre nouveau\ngrade sur votre Badge d'Explorateur.", german="Ich muss euren neuen Rang auf\neurem Erkunderorden vermerken.", italian="Devo segnare il nuovo rango\nsulla vostra Targhetta dell'esploratore.", spanish="Debo anotar el nuevo rango\nen vuestra Placa de Explorador."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_hassamu.Position; GROUND:MoveToPosition(npc_npc_hassamu, p.X+(16), p.Y+(16), false, 2) end
  GROUND:EntTurn(npc_npc_hassamu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayFanfare("Fanfare/Treasure") end) -- me_Play(9) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_hassamu) end)
  SkySceneKit.say({english="[CN]The Secret Rank mark was added\n[CN]to the Explorer Badge!", french="[CN]Le Grade Secret a été ajouté\n[CN]à votre Badge d'Explorateur!", german="[CN]Das Geheim-Rang-Abzeichen wurde\n[CN]dem Erkunderorden hinzugefügt!", italian="[CN]Il Rango Segreto è stato\n[CN]aggiunto alla Targhetta dell'esploratore!", spanish="[CN]¡Se añadió el Rango Secreto\n[CN]a la Placa de Explorador!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_hassamu.Position; GROUND:MoveToPosition(npc_npc_hassamu, p.X+(-16), p.Y+(-16), false, 2) end
  GROUND:EntTurn(npc_npc_hassamu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  else
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I don't have a clue what you did\nfor us, but...[K]thank you.", french="Je ne comprends pas du tout\nce que vous avez fait pour nous, mais bon...[K]\nmerci.", german="Ich habe keinen Schimmer, was\ndu für uns getan hast, aber...[K] danke schön.", italian="Non ho idea di cosa tu abbia\nfatto, ma...[K] grazie.", spanish="No tengo ni idea de qué has\nhecho, pero...[K] gracias."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I don't know what this is about,\nbut...[K]thank you.", french="Je ne comprends pas du tout\nce que vous avez fait pour nous, mais bon...[K]\nmerci.", german="Ich habe keine Ahnung, was es\ndamit auf sich hat, aber...[K] danke schön.", italian="Non ho idea di cosa tu abbia\nfatto, ma...[K] grazie.", spanish="No tengo ni idea de qué has\nhecho, pero...[K] gracias."})
  else
  SkySceneKit.say({english="I have no idea what this is\nabout, but...[K]thank you.", french="Je ne comprends pas du tout\nce que vous avez fait pour nous, mais bon...[K]\nmerci.", german="Ich habe keine Ahnung, was es\ndamit auf sich hat, aber...[K] danke schön.", italian="Non ho idea di cosa tu abbia\nfatto, ma...[K] grazie.", spanish="No tengo ni idea de qué has\nhecho, pero...[K] gracias."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_hassamu) end)
  SkySceneKit.say({english=" Ah, it's the least that I could do.", french="Ah, mais! C'est la moindre\ndes choses. Je suis votre obligé!", german="Ach, das war das Mindeste, was\nich für euch tun konnte.", italian="Ah, era il minimo che potessi\nfare.", spanish=" Es lo mínimo que podía hacer."})
  pcall(function() UI:SetSpeaker(npc_npc_hassamu) end)
  SkySceneKit.say({english="I shall never forget your valor\nand kindness in coming to my rescue!", french="Jamais je n'oublierai votre\nvaleur et la compassion dont vous avez fait\npreuve en me portant secours!", german="Ich werde eure Tapferkeit und\nGüte, mich zu retten, niemals vergessen!", italian="Non dimenticherò mai il valore\ne la generosità che avete dimostrato venendo\na salvarmi!", spanish="¡Nunca olvidaré vuestro valor\ny amabilidad al venir a rescatarme!"})
  pcall(function() UI:SetSpeaker(npc_npc_hassamu) end)
  SkySceneKit.say({english=" I must be on my way.[K] Farewell!", french="Il me faut prendre congé.[K]\nAdieu!", german="Ich muss mich auf den Weg\nmachen.[K] Lebt wohl!", italian=" Adesso devo andare.[K] Addio!", spanish=" Ahora debo irme.[K] ¡Adiós!"})
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_Close
  do local p=npc_npc_hassamu.Position; GROUND:MoveToPosition(npc_npc_hassamu, p.X+(180), p.Y+(0), false, 2) end
  GAME:WaitFrames(10)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweatdrop", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  else
  SkySceneKit.say({english=" .....................", french=" .....................", german=" .....................", italian=" .....................", spanish=" ..."})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  SkyProg.set(29, 39) -- $SCENARIO_MAIN = scn[29,39] (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.REQUEST_CLEAR_COUNT = 0 -- $REQUEST_CLEAR_COUNT = 0 (ROM)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  SkySceneKit.cleanup_npcs()
end
