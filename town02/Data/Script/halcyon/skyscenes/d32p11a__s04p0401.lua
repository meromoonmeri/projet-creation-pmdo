-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D32P11A/s04p0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][player] checked\n[CN]the stone marker.", french="[CN][player] examine\n[CN]la stèle.", german="[CN][player] prüft\n[CN]den Steinwegweiser.", italian="[CN][player] controlla\n[CN]la Stele.", spanish="[CN][player] miró la losa."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]There are oddly shaped grooves in it.", french="[CN]Elle est creusée d'étranges sillons.", german="[CN]Es sind seltsam geformte Rillen darauf.", italian="[CN]La superficie è attraversata da strani solchi.", spanish="[CN]Tiene inscripciones con extrañas formas."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][FT:1]ICE[FT:0]", french="[CN][FT:1]ICE[FT:0]", german="[CN][FT:1]ICE[FT:0]", italian="[CN][FT:1]ICE[FT:0]", spanish="[CN][FT:1]ICE[FT:0]"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]\"If you seek passage, close your eyes,\n[CN]then submit your proof.\"", french="[CN]\"Si vous cherchez un passage, fermez\n[CN]les yeux et présentez vos preuves.\"", german="[CN] [F:S2]Ersuchst du Durchlass,\n[CN]schließe deine Augen und\n[CN]reiche deine Berechtigung ein.[F:E2]", italian="[CN]\"Se desiderate passare, chiudete\n[CN]gli occhi e mostrate la prova.\"", spanish="[CN]\"Si buscas un pasadizo, cierra los ojos y\n[CN]sométete a la prueba.\""})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Will you close your eyes?", french="[CN]Voulez-vous fermer les yeux?", german="[CN]Willst du deine Augen schließen?", italian="[CN]Vuoi chiudere gli occhi?", spanish="[CN]¿Vas a cerrar los ojos?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(90) end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN][player] did as instructed.", french="[CN][player] suit les instructions.", german="[CN][player] folgt den Anweisungen.", italian="[CN][player] segue le istruzioni.", spanish="[CN][player] siguió las instrucciones."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  -- GAP: se_Play(7948) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(2) [anim idle native]
  if true --[[BranchDebug: retail EU]] then -- if ROM: not debug
  -- @label_2 [étiquette de flux ExplorerScript]
  -- message_Close
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_) [ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw >= 1 then
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_) [ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw >= 1 then
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_) [ProcessSpecial(PROCESS_SPECIAL_COUNT_ITEM_TYPE_IN_BAG): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw >= 1 then
  -- @label_3 [étiquette de flux ExplorerScript]
  -- message_Close
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]!!!", french="[CN]!!!", german="[CN]!!!", italian="[CN]!!!", spanish="[CN](!)"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The [CS:I]Unown Stones[CR] in the Treasure Bag:\n[CN][FT:1]I[FT:0], [FT:1]C[FT:0], and [FT:1]E[FT:0] are responding!", french="[CN]Les [CS:I]Pierres Zarbi[CR] du Sac à Trésor\n[CN][FT:1]I[FT:0], [FT:1]C[FT:0] et [FT:1]E[FT:0] réagissent!", german="[CN]Die [CS:I]Icognito-Steine[CR] [FT:1]I[FT:0], [FT:1]C[FT:0] und [FT:1]E[FT:0]\n[CN]aus dem Schatzbeutel reagieren!", italian="[CN]Le [CS:I]Pietre Unown[CR] nella Sacca dei tesori:\n[CN][FT:1]I[FT:0], [FT:1]C[FT:0] e [FT:1]E[FT:0] stanno reagendo!", spanish="[CN]¡Las [CS:I]Piedras Unown[CR]:\n[CN][FT:1]I[FT:0], [FT:1]C[FT:0] y [FT:1]E[FT:0]\n[CN]que hay en la Bolsa están reaccionando!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The activated [CS:I]Unown Stones[CR] were\n[CN]absorbed by the stone marker!", french="[CN]Les [CS:I]Pierres Zarbi[CR] sont\n[CN]absorbées par la stèle!", german="[CN]Die aktivierten [CS:I]Icognito-Steine[CR] werden\n[CN]vom Steinwegweiser absorbiert!", italian="[CN]Le [CS:I]Pietre Unown[CR] attivate sono state\n[CN]assorbite dalla Stele!", spanish="[CN]¡Las [CS:I]Piedras Unown[CR] activadas han sido\n[CN]absorbidas por la losa!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- switch(ProcessSpecial(PROCESS_SPECIAL_REMOVE_ITEMS_TYPE_IN_BAG, 408, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(PROCESS_SPECIAL_REMOVE_ITEMS_TYPE_IN_BAG, 402, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(PROCESS_SPECIAL_REMOVE_ITEMS_TYPE_IN_BAG, 404, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- se_FadeOut(7948, 15) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  GAME:WaitFrames(15)
  -- GAP: se_Play(7949) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(30)
  -- SetAnimation(5) [anim idle native]
  GAME:WaitFrames(60)
  -- SetAnimation(6) [anim idle native]
  GAME:WaitFrames(60)
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D32P44A1_84) [routine d'objet NDS non simulée - documenté]
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  -- supervision_Acting(0) [neutre/état moteur]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  SkySceneKit.offset_pos(hero, 432, 0)
  do local __slot = SkySceneKit.team_member(1); if __slot then SkySceneKit.offset_pos(__slot, 432, 0) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then SkySceneKit.offset_pos(__slot, 432, 0) end end
  do local __slot = SkySceneKit.team_member(3); if __slot then SkySceneKit.offset_pos(__slot, 432, 0) end end
  GAME:WaitFrames(45)
  GAME:FadeIn(15)
  GAME:WaitFrames(45)
  -- GAP: se_Play(8966) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The stone marker disappeared, and\n[CN]a hidden stairway was revealed!", french="[CN]La stèle disparaît,\n[CN]dévoilant un escalier caché!", german="[CN]Der Steinwegweiser ist verschwunden und\n[CN]hat eine versteckte Treppe freigelegt!", italian="[CN]La Stele scompare e al suo\n[CN]posto si materializza una scalinata!", spanish="[CN]¡La losa ha desaparecido y, en su lugar,\n[CN]hay ahora una escalera secreta!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_Close
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[43] = 1 -- $SCENARIO_MAIN_BIT_FLAG[43] = 1 (ROM)
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  elseif true then -- default
  -- debug_Print('NOE') [neutre/état moteur]
  -- @label_4 [étiquette de flux ExplorerScript]
  -- message_Close
  GAME:WaitFrames(90)
  -- SetAnimation(1) [anim idle native]
  -- se_FadeOut(7948, 90) [SE one-shot PMDO déjà terminé: fondu sans objet, canal SE V2]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]Nothing happened...", french="[CN]Rien ne se produit...", german="[CN]Nichts geschieht...", italian="[CN]Non succede niente...", spanish="[CN]No ha pasado nada..."})
  -- message_Close
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  end
  end
  elseif true then -- default
  -- debug_Print('NOC') [neutre/état moteur]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  -- debug_Print('NOI') [neutre/état moteur]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  else
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[M:D2][CS:C]Debug: Unown Rock[CR]", french="[M:D2][CS:C]Debug: Unown Rock[CR]", german="[M:D2][CS:C]Debug: Unown Rock[CR]", italian="[M:D2][CS:C]Debug: Unown Rock[CR]", spanish="[M:D2][CS:C]Debug: Unown Rock[CR]"})
  do local __choice = SkySceneKit.ask({{english="In possession.", french="In possession.", german="Im Besitz.", italian="... in possesso.", spanish="In possession."}, {english="Not in possession.", french="Not in possession.", german="Nicht im Besitz.", italian="... non in possesso.", spanish="Not in possession."}, {english="Check", french="Check", german="Prüfen", italian="Controlla", spanish="Check"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __choice == 2 then
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
end
