-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/m02a0501.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  if true --[[BranchVariation: ROM Sky EU]] then -- if ROM: variation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- switch(ProcessSpecial(53, -1, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- message_SetWaitMode(300, 300) [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Thanks for playing!\n[CN]We hope you enjoyed\n[CN]the demo!", french="[CN]Merci d'avoir joué!\n[CN]Nous espérons que vous avez\n[CN]aimé cette démo!", german="[CN]Vielen Dank fürs Spielen!\n[CN]Wir hoffen, dass dir die Demo-Version\n[CN]Spaß gemacht hat!", italian="[CN]Grazie per aver giocato!\n[CN]Ci auguriamo che la versione demo\n[CN]ti sia piaciuta!", spanish="[CN]¡Gracias por jugar!\n[CN]Para descubrir aún más aventuras,\n[CN]¡no te pierdas la versión completa!"})
  -- message_KeyWait
  -- switch(ProcessSpecial(PROCESS_SPECIAL_JUMP_TO_TITLE_SCREEN, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  else
  -- back_SetGround(LEVEL_S04P01A) [neutre/état moteur]
  GAME:FadeIn(0)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh... That didn't end well...", french=" Argh... Quel échec...", german=" Hmpf... Das lief nicht so gut.", italian="Ugh... Non è andata affatto\nbene...", spanish=" ¡Vaya! No lo hemos hecho bien..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh... That didn't go well, did it?", french=" Argh... Quel échec...", german=" Hmpf... War wohl nichts, was?", italian="Ugh... Non è andata affatto\nbene...", spanish=" ¡Vaya! Esto no ha ido muy bien..."})
  else
  SkySceneKit.say({english=" Ugh... That didn't work at all...", french=" Argh... Quel échec...", german="Hmpf... Das ging komplett\ndaneben...", italian="Ugh... Non è andata affatto\nbene...", spanish=" Ay... No nos ha salido muy bien..."})
  end
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  GAME:WaitFrames(60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  if true --[[BranchVariation: ROM Sky EU]] then -- if ROM: variation
  SkySceneKit.play_scene("d02p11a__m02a070100", "d02p11a__m02a0701", hero, partner) -- supervision_ExecuteActing(LEVEL_D02P11A, 'M02A0701', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  else
  -- back_SetGround(LEVEL_G01P03A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  GAME:WaitFrames(30)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 256, 208, Direction.Down, "NPC_PERAPPU")
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Well...[K] It appears that your\nouting was less than a total success.", french="Eh bien...[K] On dirait que votre\nexcursion n'a pas été une franche réussite.", german="Nun...[K] Eure Premiere war wohl\nnicht gerade ein großer Erfolg.", italian="Beh...[K] Si direbbe che la vostra\nmissione non sia andata esattamente secondo\ni piani.", spanish="Vaya, vaya...[K] Vuestra incursión\nno ha tenido mucho éxito que digamos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ugh...", french=" Euh...", german=" Hmpf...", italian=" Gulp...", spanish=" Uf..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ugh...", french=" Euh...", german=" Hmpf...", italian=" Gulp...", spanish=" ¡Qué vergüenza!"})
  else
  SkySceneKit.say({english=" Ugh...", french=" Euh...", german=" Hmpf...", italian=" Gulp...", spanish=" ¡Qué bochorno!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Of course, you're just beginners\nat all this. No need to fret! ♪", french="Après tout, vous n'êtes que des\nnovices. Inutile de vous tracasser! ♪", german="Natürlich seid ihr erst Anfänger.\nKein Grund für schlechte Laune! ♪", italian="Beh, siete ancora agli inizi. Non\nc'è motivo di preoccuparsi! ♪", spanish="En realidad solo sois\nprincipiantes. No hay por qué preocuparse. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(44) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="These things happen! ♪[K] You can\nattempt another challenge tomorrow! ♪", french="Ça arrive! ♪[K] Vous pourrez\nvous rattraper demain! ♪", german="So was kommt vor! ♪[K] Morgen\nkönnt ihr eine neue Herausforderung\nannehmen! ♪", italian="Capita a tutti! ♪[K]\nDomani potrete riprovare! ♪", spanish="¡Estas cosas pasan! ♪[K] ¡Ya lo\nintentaréis de nuevo mañana! ♪"})
  -- message_Close
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(2) -- join WaitBgm
  end
  end
  SkySceneKit.cleanup_npcs()
end
