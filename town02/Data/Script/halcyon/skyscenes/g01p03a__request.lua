-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/request.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- debug_Print('acting_REQUEST') [neutre/état moteur]
  do local __sw = ((SV.SkyMenuResults or {})["MENU_JOB_REWARD_TYPE"] or 0) -- switch(message_Menu(MENU_JOB_REWARD_TYPE)) [message_Menu(MENU_JOB_REWARD_TYPE): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == -1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  elseif __sw == 9 then
  -- back_SetGround(LEVEL_G01P03A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(4) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(444, 248, 1, false) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_JOB_CLEAR non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- switch(message_Menu(MENU_JOB_REWARD_TEXT)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- @label_10 [étiquette de flux ExplorerScript]
  pcall(function() SOUND:FadeOutBGM(30) end)
  GAME:FadeOut(false, 30)
  -- supervision_Suspend(-2) [neutre/état moteur]
  -- supervision_RemoveActing(-2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 10 then
  -- back_SetGround(LEVEL_G01P03A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(5) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(444, 248, 1, false) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_JOB_CLEAR non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- switch(message_Menu(MENU_JOB_REWARD_TEXT)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  local npc_npc_jibakoiru = SkySceneKit.spawn_npc("magnezone", 448, 240, Direction.Down, "NPC_JIBAKOIRU")
  pcall(function() UI:SetSpeaker(npc_npc_jibakoiru) end)
  SkySceneKit.say({english="ZZZT! Thank you for your\ncooperation! ZZZT!", french="ZZZT! Merci de votre\ncoopération! ZZZT!", german="ZZZT! Vielen Dank für eure\nMitarbeit! ZZZT!", italian="ZZZT! Grazie per la vostra\ncooperazione! ZZZT!", spanish="¡Bzz! ¡Gracias por vuestra\ncooperación! ¡Bzz!"})
  -- message_Close
  -- GAP: se_Play(6418) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(npc_npc_jibakoiru, "happy", 1) end)
  local npc_npc_koiru = SkySceneKit.spawn_npc("magnemite", 472, 216, Direction.Down, "NPC_KOIRU")
  pcall(function() GROUND:CharSetEmote(npc_npc_koiru, "happy", 1) end)
  local npc_npc_koiru2 = SkySceneKit.spawn_npc("magnemite", 424, 216, Direction.Down, "NPC_KOIRU2")
  pcall(function() GROUND:CharSetEmote(npc_npc_koiru2, "happy", 1) end)
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_jibakoiru, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_koiru, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_koiru2, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(20)
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 12 then
  -- back_SetGround(LEVEL_G01P03A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(6) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(252, 240, 1, false) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_JOB_CLEAR non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 256, 224, Direction.Down, "NPC_PERAPPU")
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="What?!? [K]You mean, there was a\nhidden room?", french="Comment?!? [K]Vous voulez dire\nqu'il y avait une Salle Secrète?", german="Wie bitte?!? [K]Du meinst, dort\nwar ein versteckter Raum?", italian="Cosa?!? [K]Avete scoperto una\nstanza segreta?", spanish="¿¡Cómo!?[K] ¿Que había\nuna sala oculta?"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Not only that, but you brought\nall the treasure back with you?!", french="Et que, par-dessus le marché,\nvous avez ramené le trésor avec vous?!", german="Und nicht nur das, ihr habt auch\neinen Schatz mitgebracht?!?", italian="E avete anche riportato tutto\nil tesoro?!", spanish="¡¿Y además habéis traído\nel tesoro que escondía?!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Isn't that wonderful. ♪[K]\nBut you know what? I'll keep the treasure.", french="C'est absolument fantastique! ♪[K]\nVous savez quoi? Je vais garder le trésor.", german="Ist das nicht wundervoll?!? ♪[K]\nWisst ihr was? Ich werde den Schatz behalten.", italian="Ma è meraviglioso! ♪[K]\nSapete una cosa? Penso che lo terrò io.", spanish="Pero qué maravilla. ♪[K]\n¿Sabéis qué? Ya me encargo yo de custodiarlo."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="...Just kidding. It's a reward. ♪[K]\nHow about you keep it? ♪", french="... Non, je plaisante! C'est votre\nrécompense.[K] Vous pouvez garder ce trésor! ♪", german="Nur ein Scherz. ♪ [K] Den kriegt\nihr als Belohnung. Wie wäre es damit? ♪", italian="... Scherzo. È la vostra\nricompensa. ♪[K] Tenetelo pure! ♪", spanish="Es broma, es broma. ♪[K]\n¿Y si os lo quedáis como recompensa? ♪"})
  -- message_Close
  GAME:WaitFrames(20)
  -- switch(message_Menu(MENU_JOB_REWARD_TEXT)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 11 then
  -- back_SetGround(LEVEL_G01P03A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(7) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(252, 240, 1, false) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_JOB_CLEAR non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- switch(message_Menu(MENU_JOB_REWARD_TEXT)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_5 [étiquette de flux ExplorerScript]
  -- back_SetGround(LEVEL_G01P03A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  do local __sw = ((SV.SkyMenuResults or {})["MENU_JOB_REWARD_NPC_AMOUNT"] or 0) -- switch(message_Menu(MENU_JOB_REWARD_NPC_AMOUNT)) [message_Menu(MENU_JOB_REWARD_NPC_AMOUNT): menu moteur NDS (retour par défaut 0, branches préservées)]
  if __sw == 2 then
  -- supervision_Acting(2) [neutre/état moteur]
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 3 then
  -- supervision_Acting(3) [neutre/état moteur]
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- supervision_Acting(1) [neutre/état moteur]
  -- @label_9 [étiquette de flux ExplorerScript]
  pcall(function() GAME:MoveCamera(252, 240, 1, false) end)
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_JOB_CLEAR non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- switch(message_Menu(MENU_JOB_REWARD_TEXT)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  SkySceneKit.cleanup_npcs()
end
