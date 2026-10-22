-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P21A/s32a0401.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- supervision_Acting(0) [neutre/état moteur]
  -- item_Set(0, 70, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  -- item_Set(1, 330, 0) [table d'objets du script NDS: inventaire géré par le moteur PMDO]
  GAME:WaitFrames(1)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  local npc_npc_herakurosu = SkySceneKit.spawn_npc("heracross", 296, 280, Direction.Left, "NPC_HERAKUROSU")
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english=" Oh no!", french=" Oh non!", german=" Oh nein!", italian=" Oh no!", spanish=" ¡Oh, no!"})
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="I completely forgot to bring the\n[s_item:0]!", french="J'ai complètement oublié\nd'amener l'objet [s_item:0]!", german="Ich habe total vergessen, das\nItem [s_item:0] mitzunehmen!", italian="Mi sono completamente\ndimenticato di portare il mio strumento\n[s_item:0]!", spanish="¡Me he dejado el objeto\n[s_item:0] en casa!"})
  -- message_KeyWait
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english=" I'm so forgetful!", french=" Que je suis tête en l'air!", german=" Ich bin so vergesslich!", italian=" Che sbadato!", spanish=" ¡Qué despistado soy!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="[CN]Give the [s_item:0]?", french="[CN]Donner l'objet [s_item:0]?", german="[CN]Das Item [s_item:0] übergeben?", italian="[CN]Vuoi regalare lo strumento [s_item:0]?", spanish="[CN]¿Dar el objeto [s_item:0]?"})
  do local __choice = SkySceneKit.ask({{english="Yes", french="Oui", german="Ja", italian="Sì", spanish="Sí"}, {english="No", french="Non", german="Nein", italian="No", spanish="No"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_COUNT_TABLE_ITEM_TYPE_IN_BAG"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_COUNT_TABLE_ITEM_TY) [ProcessSpecial(PROCESS_SPECIAL_COUNT_TABLE_ITEM_TYPE_IN_BAG): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw >= 1 then
  -- switch(ProcessSpecial(PROCESS_SPECIAL_REMOVE_ITEMS_TYPE_IN_BAG, 70, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- switch(ProcessSpecial(PROCESS_SPECIAL_ADD_TABLE_ITEM_TO_BAG, 1, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[91] = 1 -- $SCENARIO_MAIN_BIT_FLAG[91] = 1 (ROM)
  -- GAP: se_Play(8710) — id SE NDS sans portage PMDO identifié
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="[CN][player] gave the\n[CN][s_item:0].", french="[CN][player] donne l'objet\n[CN][s_item:0].", german="[CN][player] übergibt\n[CN]das Item [s_item:0].", italian="[CN][player] ha regalato lo strumento\n[CN][s_item:0].", spanish="[CN]¡[player] ha entregado el objeto\n[CN][s_item:0]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8969) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_sheimi = SkySceneKit.spawn_npc("shaymin", 232, 448, Direction.Up, "NPC_SHEIMI")
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sheimi, hero, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="Woo-hoo!\nFor me?", french="Youhou!\nPour moi?", german="Oh, wow!\nFür mich?", italian="Yuhuuu!\nÈ per me?", spanish="¡Hala!\n¿Es para mí?"})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="Really?!\nYou're really a great friend!!", french="Vraiment?!\nC'est merveilleux d'être ton ami, vraiment!!", german="Wirklich?!?\nDu bist einfach großartig!!!", italian="Davvero?!\nSei davvero molto gentile!!!", spanish="¡¿De verdad?!\n¡Tanta generosidad me conmueve!"})
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english=" I'll find a way to pay you back!", french="Je trouverai un moyen de te\nrendre la pareille!", german="Ich werde eine Möglichkeit\nfinden, mich zu revanchieren!", italian="Devo trovare un modo\nper ripagarti!", spanish="Ya pensaré en alguna forma\nde compensarte."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_herakurosu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english=" Oh, that's right...! Here!", french=" Oh, mais justement...! Tiens!", german=" Oh, genau! Hier!", italian=" Oh, giusto...! Ecco qua!", spanish=" Ah, ya sé... Toma."})
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="This is the best item I have\nwith me right now.[K] The [s_item:1]!", french="C'est le meilleur objet que je\npossède en ce moment:[K] [s_item:1]!", german="Es ist das beste Item, das ich\nbesitze.[K] Das Item [s_item:1]!", italian="Questo è il massimo che ti posso\ndare adesso.[K] È lo strumento [s_item:1]!", spanish="Es lo mejorcito que llevo encima\nen este momento.[K] ¡Un objeto [s_item:1]!"})
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="Please take this as a token of\nmy gratitude!", french="S'il te plaît, accepte ce cadeau\nen signe de gratitude!", german="Bitte nimm es als Zeichen\nmeiner Dankbarkeit!", italian="È il mio modo di ringraziarti.\nPer favore, accettalo!", spanish="Acéptalo como muestra\nde mi agradecimiento."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayFanfare("Fanfare/Item") end) -- me_Play(4) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="[CN][player] received the\n[CN][s_item:1] as thanks!", french="[CN][player] reçoit l'objet\n[CN][s_item:1] en gage de remerciement!", german="[CN][player] erhält zum Dank\n[CN]das Item [s_item:1]!", italian="[CN][player] ha ricevuto lo strumento\n[CN][s_item:1] come ringraziamento!", spanish="[CN]¡[player] ha obtenido el objeto\n[CN][s_item:1] como agradecimiento!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_herakurosu) end)
  SkySceneKit.say({english="I won't forget this favor!\nThank you!", french="Je n'oublierai pas ce coup\nde pouce! Merci!", german="Das werde ich nicht vergessen.\nVielen Dank!", italian="Non dimenticherò il favore\nche mi hai fatto! Grazie!", spanish="Nunca olvidaré el favor que me\nhas hecho. ¡Gracias!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  -- SetPositionLives(4) [cible objet/id de décor NDS non simulée - trace]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() local p=npc_npc_sheimi.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_NPC_SHEIMI
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi, "happy", 1) end)
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Hee-hee-hee. You're really nice,\naren't you, [player]?", french="Hi hi hi. Tu es vraiment sympa,\npas vrai, [player]?", german="Hi-hi-hi. Du bist wirklich\nnett, nicht wahr, [player]?", italian="Ih ih ih. Hai davvero\nun cuore d'oro, [player], lo sai?", spanish="Ji, ji, ji. [player], eres\nde lo más dulce, ¿eh?"})
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_sheimi, 4) end)
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_sheimi, nil, 0) end) -- EFFECT_NONE
  -- message_FacePositionOffset(0, 2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="Mountain climbing is give\nand take.", french="Escalader une montagne nous\noffre la possibilité de recevoir\naussi bien que d'offrir.", german="Bergsteigen beinhaltet Geben\nund Nehmen.", italian="La montagna risveglia\nla generosità che è in noi.", spanish="Hay que ser generosos durante\nel ascenso a una montaña."})
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="We should help others when\nthey're in trouble.", french="On devrait prêter main forte\nà ceux qui rencontrent des problèmes.", german="Wir sollten anderen helfen,\nwenn sie in Not geraten sind.", italian="Dovremmo sempre aiutare chi\nsi trova in difficoltà.", spanish="Deberíamos ayudar a los demás\ncuando estén en apuros."})
  -- message_Close
  pcall(function() local p=hero.Position; GAME:MoveCamera(p.X, p.Y, 60, false) end) -- MovePositionLives performer/caméra vers ACTOR_PLAYER_APPOINT
  -- SetAnimation(4) [anim idle native]
  GROUND:EntTurn(npc_npc_sheimi, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  elseif true then -- default
  pcall(function() UI:SetSpeaker(npc_npc_sheimi) end)
  SkySceneKit.say({english="[CN]Don't have the [s_item:0]...?", french="[CN]Vous n'avez pas d'objet [s_item:0]...?", german="[CN]Das Item [s_item:0] hast du nicht?", italian="[CN]Non hai lo strumento [s_item:0]...?", spanish="[CN]¿No tienes el objeto [s_item:0]?"})
  -- message_Close
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  else -- default/annulation
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  SkySceneKit.cleanup_npcs()
end
