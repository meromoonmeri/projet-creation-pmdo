-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D30P32A/m26a0308.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Restored.ogg", true) end)
  -- back_SetGround(LEVEL_D30P32A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(60)
  GAME:WaitFrames(30)
  local npc_npc_diaruga = SkySceneKit.spawn_npc("dialga", 280, 376, Direction.Up, "NPC_DIARUGA")
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="[CS:P]TEMPORAL TOWER[CR] SURVIVED\nTHE CRISIS.[K] TIME HAS RETURNED TO NORMAL\nHERE...", french="LA [CS:P]TOUR DU TEMPS[CR] A RESISTE\nA LA CATASTROPHE.[K] LE TEMPS A REPRIS\nSON COURS ICI...", german="DER [CS:P]ZEITTURM[CR] HAT DIE KRISE\nÜBERSTANDEN.[K] DIE ZEIT IST HIER ZUR\nNORMALITÄT ZURÜCKGEKEHRT...", italian="LA [CS:P]TORRE DEL TEMPO[CR] È\nSOPRAVVISSUTA ALLA CRISI.[K] IL TEMPO\nQUI È TORNATO AL SUO CORSO NORMALE...", spanish="LA [CS:P]TORRE DEL TIEMPO[CR] SE\nHA SALVADO.[K] EL TIEMPO HA VUELTO A\nLA NORMALIDAD."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="THUS, TIME HAS RESUMED IN\nPLACES WHERE IT HAD STOPPED.", french="AINSI QUE PARTOUT OU IL\nS'ETAIT ARRETE.", german="FOLGLICH GEHT DIE ZEIT AUCH\nWIEDER DORT IHREN NORMALEN GANG, WO SIE\nVORHER ANGEHALTEN HAT.", italian="E COSÌ, È TORNATO A SCORRERE\nANCHE NEI LUOGHI IN CUI SI ERA FERMATO.", spanish="EL PASO DEL TIEMPO SE HA\nREANUDADO EN LOS LUGARES DONDE\nSE HABÍA DETENIDO."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="BECAUSE YOU STOPPED THE\nRUIN OF [CS:P]TEMPORAL TOWER[CR]...", french="PARCE QUE VOUS AVEZ MIS\nUN TERME A L'EFFONDREMENT DE LA [CS:P]TOUR\nDU TEMPS[CR]...", german="UND DAS, WEIL IHR DEN\nZUSAMMENBRUCH DES [CS:P]ZEITTURMS[CR] VERHINDERT\nHABT...", italian="POICHÉ VOI AVETE\nSCONGIURATO LA DISTRUZIONE DELLA\n[CS:P]TORRE DEL TEMPO[CR]...", spanish="AL IMPEDIR QUE LA [CS:P]TORRE DEL[CR]\n[CS:P]TIEMPO[CR] SE DERRUMBARA..."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="THE PLANET'S PARALYSIS HAS\nBEEN PREVENTED.", french="LA PARALYSIE DE LA PLANETE\nA ETE EVITEE.", german="DADURCH WURDE AUCH DIE\nLÄHMUNG DES PLANETEN VERHINDERT.", italian="AVETE PREVENUTO LA PARALISI\nDEL PIANETA.", spanish="HABÉIS EVITADO LA PARÁLISIS\nDEL PLANETA."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="THE WORLD'S PEACE...[K]HAS BEEN\nRESTORED.", french="LA PAIX...[K] EST REVENUE\nDANS LE MONDE.", german="DER WELTFRIEDEN...[K] WURDE\nWIEDERHERGESTELLT.", italian="AVETE RIPORTATO...[K] LA PACE\nNEL MONDO.", spanish="LA PAZ...[K] HA VUELTO A\nRESTABLECERSE."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" R-really?!", french=" Vraiment?!", german=" W-wirklich?", italian=" D-Davvero?!", spanish=" ¡¿De... de verdad?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" R-really?!", french=" Vraiment?!", german=" W-wirklich?", italian=" D-Davvero?!", spanish=" ¡¿De... de verdad?!"})
  else
  SkySceneKit.say({english=" R-really?!", french=" Vraiment?!", german=" W-wirklich?", italian=" D-Davvero?!", spanish=" ¡¿De... de verdad?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(20)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We did it, [hero]!", french=" On a réussi, [hero]!", german="Wir haben es geschafft,\n[hero]!", italian="Ce l'abbiamo fatta,\n[hero]!", spanish=" ¡Lo logramos, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We did it, [hero]!", french=" On a réussi, [hero]!", german="Wir haben es geschafft,\n[hero]!", italian="Ce l'abbiamo fatta,\n[hero]!", spanish=" ¡Lo logramos, [hero]!"})
  else
  SkySceneKit.say({english=" We did it, [hero]!", french=" On a réussi, [hero]!", german="Wir haben es geschafft,\n[hero]!", italian="Ce l'abbiamo fatta,\n[hero]!", spanish=" ¡Lo logramos, [hero]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We finally did it!", french=" On a enfin réussi!", german="Wir haben es letztendlich\ngeschafft!", italian=" Alla fine ce l'abbiamo fatta!", spanish=" ¡Por fin lo conseguimos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We finally did it!", french=" On a enfin réussi!", german="Wir haben es letztendlich\ngeschafft!", italian=" Alla fine ce l'abbiamo fatta!", spanish=" ¡Por fin lo conseguimos!"})
  else
  SkySceneKit.say({english=" We finally did it!", french=" On a enfin réussi!", german="Wir haben es letztendlich\ngeschafft!", italian=" Alla fine ce l'abbiamo fatta!", spanish=" ¡Por fin lo conseguimos!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We brought peace to the world!", french="On a ramené la paix\ndans le monde!", german="Wir haben der Welt Frieden\ngebracht!", italian="Abbiamo riportato la pace nel\nmondo!", spanish="¡Hemos devuelto la tranquilidad\na este mundo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We brought peace to the world!", french="On a ramené la paix\ndans le monde!", german="Wir haben der Welt Frieden\ngebracht!", italian="Abbiamo riportato la pace nel\nmondo!", spanish="¡Hemos devuelto la tranquilidad\na este mundo!"})
  else
  SkySceneKit.say({english=" We brought peace to the world!", french="On a ramené la paix\ndans le monde!", german="Wir haben der Welt Frieden\ngebracht!", italian="Abbiamo riportato la pace nel\nmondo!", spanish="¡Hemos devuelto la tranquilidad\na este mundo!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_diaruga, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_diaruga, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english=" ALLOW ME TO THANK YOU.", french="PERMETTEZ-MOI DE VOUS\nREMERCIER.", german=" ERLAUBT MIR, EUCH ZU DANKEN.", italian=" PERMETTETE CHE VI RINGRAZI.", spanish="PERMITIDME QUE OS DÉ LAS\nGRACIAS."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="I THANK YOU FOR REACHING THE\n[CS:P]HIDDEN LAND[CR]...", french="MERCI D'AVOIR ATTEINT LES\n[CS:P]TERRES ILLUSOIRES[CR]...", german="ICH DANKE EUCH DAFÜR, DASS\nIHR DAS [CS:P]VERBORGENE LAND[CR] ERREICHT HABT...", italian="GRAZIE PER AVER RAGGIUNTO LA\n[CS:P]TERRA NASCOSTA[CR]...", spanish="OS DOY LAS GRACIAS POR\nHABER LLEGADO A LA [CS:P]TIERRA OCULTA[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="YOU HAD THE COURAGE TO\nSTAND UP TO ME, EVEN AS I RAGED OUT\nOF CONTROL...", french="VOUS AVEZ EU LE COURAGE\nDE M'AFFRONTER, ALORS MEME QUE J'ETAIS\nDECHAINE...", german="IHR HATTET DEN MUT, EUCH MIR\nENTGEGENZUSTELLEN. IN EINEM MOMENT, ALS\nICH VOR ZORN DIE KONTROLLE VERLOR...", italian="PER AVER AVUTO IL CORAGGIO\nDI AFFRONTARMI, ANCHE SE AVEVO PERSO\nIL CONTROLLO...", spanish="HABÉIS TENIDO EL VALOR DE\nENFRENTAROS A MÍ, PESE A QUE ESTABA\nFUERA DE CONTROL..."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="AND YOU PREVENTED THE RUIN\nOF [CS:P]TEMPORAL TOWER[CR] IN THE NICK OF TIME.", french="ET VOUS AVEZ EVITE DE\nJUSTESSE L'EFFONDREMENT DE LA [CS:P]TOUR\nDU TEMPS[CR].", german="UND IHR VERHINDERTET GERADE\nNOCH RECHTZEITIG DEN EINSTURZ DES\n[CS:P]ZEITTURMS[CR].", italian="... E PER AVER EVITATO LA\nDISTRUZIONE DELLA [CS:P]TORRE DEL TEMPO[CR]\nALL'ULTIMO MOMENTO.", spanish="Y HABÉIS EVITADO LA CAÍDA\nDE LA [CS:P]TORRE DEL TIEMPO[CR] ANTES DE QUE\nFUERA DEMASIADO TARDE."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="THANK YOU.[K] ALL THIS, I OWE\nTO YOU.", french="MERCI.[K] TOUT CELA, C'EST\nA VOUS QUE JE LE DOIS.", german="DANKE.[K] FÜR ALL DIES STEHE ICH\nIN EURER SCHULD.", italian="GRAZIE.[K] TUTTO QUESTO LO\nDEVO A VOI.", spanish="MUCHAS GRACIAS.[K] OS DEBO\nMUCHÍSIMO."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]D-Dialga[CR]...", french=" [CS:N]D-Dialga[CR]...", german=" [CS:N]D-Dialga[CR]...", italian=" [CS:N]D-Dialga[CR]...", spanish=" [CS:N]Dialga[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]D-Dialga[CR]...", french=" [CS:N]D-Dialga[CR]...", german=" [CS:N]D-Dialga[CR]...", italian=" [CS:N]D-Dialga[CR]...", spanish=" [CS:N]Dialga[CR]..."})
  else
  SkySceneKit.say({english=" [CS:N]D-Dialga[CR]...", french=" [CS:N]D-Dialga[CR]...", german=" [CS:N]D-Dialga[CR]...", italian=" [CS:N]D-Dialga[CR]...", spanish=" [CS:N]Dialga[CR]..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="BUT ALL IS NOT YET AS IT\nSHOULD BE... IT WILL TAKE TIME.", french="MAIS TOUT N'EST PAS ENCORE\nREVENU A LA NORMALE... CELA PRENDRA\nDU TEMPS.", german="ABER LEIDER IST NOCH NICHT\nALLES, WIE ES SEIN SOLLTE... ES WIRD\nETWAS MEHR ZEIT IN ANSPRUCH NEHMEN.", italian="MA NON È ANCORA TORNATO\nTUTTO ALLA NORMALITÀ... CI VORRÀ UN\nPO'.", spanish="AÚN NO ESTÁ TODO COMO\nDEBERÍA... LA NORMALIDAD TARDARÁ UN\nPOCO EN RESTABLECERSE."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="I MUST SEE TO THE REPAIR OF\n[CS:P]TEMPORAL TOWER[CR].", french="JE DOIS VEILLER A LA\nRESTAURATION DE LA [CS:P]TOUR DU TEMPS[CR].", german="ICH MUSS MICH UM DIE\nREPARATUR DES [CS:P]ZEITTURMS[CR] KÜMMERN.", italian="BISOGNERÀ RIPARARE LA\n[CS:P]TORRE DEL TEMPO[CR].", spanish="DEBO ENCARGARME DE REPARAR\nLA [CS:P]TORRE DEL TIEMPO[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_diaruga, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="THE [CS:P]HIDDEN LAND[CR], TOO, HAS\nBEEN RAVAGED...", french="LES [CS:P]TERRES ILLUSOIRES[CR] ONT\nELLES AUSSI ETE DEVASTEES...", german="AUCH DAS [CS:P]VERBORGENE LAND[CR]\nWURDE VERWÜSTET...", italian="ANCHE LA [CS:P]TERRA NASCOSTA[CR]\nÈ STATA DEVASTATA...", spanish="LA [CS:P]TIERRA OCULTA[CR] TAMBIÉN\nHA SUFRIDO SERIOS DAÑOS..."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="BUT THE RAINBOW STONESHIP\nSHOULD STILL BE OPERABLE...", french="MAIS LE VAISSEAU ARC-EN-CIEL\nDEVRAIT ENCORE FONCTIONNER...", german="ABER DAS\nREGENBOGEN-STEINSCHIFF SOLLTE NOCH\nFUNKTIONSTÜCHTIG SEIN...", italian="MA IL VASCELLO ARCOBALENO\nNON DOVREBBE AVER SUBITO DANNI...", spanish="PERO LA BARCA ARCOIRIS AÚN\nPUEDE REALIZAR EL VIAJE DE VUELTA..."})
  pcall(function() UI:SetSpeaker(npc_npc_diaruga) end)
  SkySceneKit.say({english="AND [CS:N]LAPRAS[CR] SHOULD BE\nAWAITING YOUR RETURN.", french="ET [CS:N]LOKHLASS[CR] DOIT ATTENDRE\nVOTRE RETOUR.", german="UND [CS:N]LAPRAS[CR] WARTET SICHER\nBEREITS AUF EURE RÜCKKEHR.", italian="E [CS:N]LAPRAS[CR] STARÀ ASPETTANDO\nCHE TORNIATE.", spanish="Y [CS:N]LAPRAS[CR] OS ESTARÁ\nESPERANDO."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_diaruga, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" OK!", french=" Super!", german=" Okay!", italian=" Ok!", spanish=" De acuerdo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK!", french=" Super!", german=" Okay!", italian=" Ok!", spanish=" De acuerdo."})
  else
  SkySceneKit.say({english=" OK!", french=" Super!", german=" Okay!", italian=" Ok!", spanish=" De acuerdo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's go home, [hero]!", french="On rentre chez nous,\n[hero]!", german="Gehen wir nach Hause,\n[hero]!", italian=" Torniamo a casa, [hero]!", spanish=" Vámonos a casa, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go home, [hero]!", french="On rentre chez nous,\n[hero]!", german="Gehen wir nach Hause,\n[hero]!", italian=" Torniamo a casa, [hero]!", spanish=" Vámonos a casa, [hero]."})
  else
  SkySceneKit.say({english=" Let's go home, [hero]!", french="On rentre chez nous,\n[hero]!", german="Gehen wir nach Hause,\n[hero]!", italian=" Torniamo a casa, [hero]!", spanish=" Vámonos a casa, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Back to Treasure Town!", french=" En route pour Bourg-Trésor!", german=" Zurück nach Schatzstadt!", italian=" Torniamo a Borgo Tesoro!", spanish=" ¡De vuelta a Aldea Tesoro!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Back to Treasure Town!", french=" En route pour Bourg-Trésor!", german=" Zurück nach Schatzstadt!", italian=" Torniamo a Borgo Tesoro!", spanish=" ¡De vuelta a Aldea Tesoro!"})
  else
  SkySceneKit.say({english=" Back to Treasure Town!", french=" En route pour Bourg-Trésor!", german=" Zurück nach Schatzstadt!", italian=" Torniamo a Borgo Tesoro!", spanish=" ¡De vuelta a Aldea Tesoro!"})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(160) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(90)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[8] = 1 -- $SCENARIO_MAIN_BIT_FLAG[8] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.COMPULSORY_SAVE_POINT = 22 -- $COMPULSORY_SAVE_POINT = 22 (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
