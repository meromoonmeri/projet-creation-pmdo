-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/s03p0301.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(29, 42) -- $SCENARIO_MAIN = scn[29,42] (ROM)
  -- switch(ProcessSpecial(PROCESS_SPECIAL_REMOVE_ITEMS_TYPE_IN_BAG, 178, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]The next morning...", french="[CN]Le lendemain matin...", german="[CN]Am nächsten Morgen...", italian="[CN]La mattina dopo...", spanish="[CN]Al día siguiente..."})
  -- message_Close
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V24P08A) [décor sub chargé: Sub_v24p08a]
  -- back_SetGround(LEVEL_H02P99A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 19, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  GROUND:EntTurn(partner, Direction.Left)
  -- SetAnimation(76) [anim idle native]
  -- SetAnimation(76) [anim idle native]
  -- SetOutputAttribute(4) [neutre/état moteur]
  SkySubScreen.Show("v24p08a", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(30)
  -- GAP: BGM BGM_DO_YOUR_BEST_AS_ALWAYS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(5)
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Down)
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Good morning, [hero]!", french=" Bonjour, [hero]!", german=" Guten Morgen, [hero]!", italian=" Buongiorno, [hero]!", spanish=" ¡Buenos días, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Good morning, [hero]!", french=" Bonjour, [hero]!", german=" Guten Morgen, [hero]!", italian=" Buongiorno, [hero]!", spanish=" ¡Buenos días, [hero]!"})
  else
  SkySceneKit.say({english=" Good morning, [hero]!", french=" Bonjour, [hero]!", german=" Guten Morgen, [hero]!", italian=" Buongiorno, [hero]!", spanish=" ¡Buenos días, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey, that Egg we found at the\n[CS:P]Surrounded Sea[CR] yesterday...", french="Hé, cet Œuf qu'on a trouvé\nà la [CS:P]Mer Fermée[CR] hier...", german="Hey, dieses Ei, das wir gestern\nim [CS:P]Ringmeer[CR] gefunden haben...", italian="Ehi, quell'Uovo che abbiamo\ntrovato nel [CS:P]Mar Cinto[CR] ieri...", spanish="Oye, el Huevo que encontramos\nayer en el [CS:P]Mar Circundante[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You know, that Egg we found at\nthe [CS:P]Surrounded Sea[CR] yesterday...", french="Hé, cet Œuf qu'on a trouvé\nà la [CS:P]Mer Fermée[CR] hier...", german="Weißt du, dieses Ei, das wir\ngestern im [CS:P]Ringmeer[CR] gefunden haben...", italian="Ehi, quell'Uovo che abbiamo\ntrovato nel [CS:P]Mar Cinto[CR] ieri...", spanish="Oye, te acuerdas del Huevo que\nencontramos ayer en el [CS:P]Mar Circundante[CR]..."})
  else
  SkySceneKit.say({english="Say, that Egg we found at the\n[CS:P]Surrounded Sea[CR] yesterday...", french="Hé, cet Œuf qu'on a trouvé\nà la [CS:P]Mer Fermée[CR] hier...", german="Sag mal, dieses Ei, das wir\ngestern im [CS:P]Ringmeer[CR] gefunden haben...", italian="Ehi, quell'Uovo che abbiamo\ntrovato nel [CS:P]Mar Cinto[CR] ieri...", spanish="Oye, el Huevo que encontramos\nayer en el [CS:P]Mar Circundante[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="With such weird colors, it sure\nlooks mystical.[K] What do you think is in it?", french="Il brille d'une lueur si\nmystérieuse...[K] Tu penses qu'il y a quoi\nà l'intérieur?", german="Das hat so seltsame Farben. Es\nsieht sehr mysteriös aus.[K] Was, glaubst du,\nist wohl in diesem Ei?", italian="Ha dei colori strani, un aspetto\ndavvero mistico.[K]\nCosa pensi che contenga?", spanish="Tiene un aire misterioso, con\nesos colores tan raros.[K] ¿Qué habrá dentro?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's glowing with this mystical\nlight, isn't it?[K] What do you think is in it?", french="Il brille d'une lueur si\nmystérieuse...[K] Tu penses qu'il y a quoi\nà l'intérieur?", german="Es glüht mit diesem mystischen\nLicht.[K] Was, glaubst du, ist wohl in diesem Ei?", italian="Con quegli strani colori, ha un\naspetto davvero mistico.[K]\nCosa pensi che contenga?", spanish="Tiene un aire misterioso, con\nesos colores tan raros.[K] ¿Qué habrá dentro?"})
  else
  SkySceneKit.say({english="It's got a strange glow to it,\ndoesn't it?[K] What do you think is in it?", french="Il brille d'une lueur si\nmystérieuse...[K] Tu penses qu'il y a quoi\nà l'intérieur?", german="Es glüht ziemlich merkwürdig,\nfindest du nicht?[K] Was, glaubst du, ist wohl\nin diesem Ei?", italian="Con quegli strani colori, ha un\naspetto davvero mistico.[K]\nCosa pensi che contenga?", spanish="Tiene un brillo extraño,\n¿verdad?[K] ¿Qué habrá dentro?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(60) end)
  pcall(function() GAME:MoveCamera(304, 204, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 292, 212, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(hero, 324, 212, false, 2)
  GROUND:EntTurn(hero, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  -- GAP: se_Play(7957) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D34P41A1_89) [routine d'objet NDS non simulée - documenté]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa! It moved!", french=" Oooh! Il a bougé!", german=" Holla! Es hat sich bewegt!", italian=" Wow! Si è mosso!", spanish=" ¡Atiza! ¡Se mueve!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Wa-waah! It moved!", french=" Oooh! Il a bougé!", german=" Ua-aaah! Es hat sich bewegt!", italian=" Wa-Waah! Si è mosso!", spanish=" ¿Quéee? ¡Se ha movido!"})
  else
  SkySceneKit.say({english=" Wa-waah! It moved!", french=" Oooh! Il a bougé!", german=" Ua-aaah! Es hat sich bewegt!", italian=" Wa-Waah! Si è mosso!", spanish=" ¿Quéee? ¡Se ha movido!"})
  end
  -- message_Close
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey, [hero]![K] The Egg\ndid move just now, didn't it?", french="Dis, [hero]![K] L'Œuf,\nil a bien bougé, je n'ai pas rêvé?", german="Hey, [hero]![K] Das Ei hat\nsich gerade bewegt, oder etwa nicht?", italian="Ehi, [hero]![K] L'Uovo si è\nappena mosso, vero?", spanish="¡Oye, [hero]![K] El Huevo\nse acaba de mover, ¿verdad?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hey, [hero]![K] The Egg\ndid move just now, didn't it?", french="Dis, [hero]![K] L'Œuf,\nil a bien bougé, je n'ai pas rêvé?", german="Hey, [hero]![K] Das Ei hat\nsich gerade bewegt, oder etwa nicht?", italian="Ehi, [hero]![K] L'Uovo si è\nappena mosso, vero?", spanish="¡Oye, [hero]![K] El Huevo\nse acaba de mover, ¿verdad?"})
  else
  SkySceneKit.say({english="Say, [hero].[K] The Egg\ndid move just now, didn't it?", french="Dis, [hero]![K] L'Œuf,\nil a bien bougé, je n'ai pas rêvé?", german="Sag mal, [hero]![K] Hat sich\ndas Ei da gerade etwa bewegt?", italian="Ehi, [hero]![K] L'Uovo si è\nappena mosso, vero?", spanish="¡Oye, [hero]![K] El Huevo\nse acaba de mover, ¿verdad?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  -- GAP: se_Play(7957) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D34P41A1_89) [routine d'objet NDS non simulée - documenté]
  -- GAP: se_Play(7957) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_D34P41A1_89) [routine d'objet NDS non simulée - documenté]
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, [hero]![K] The Egg is...", french=" Oh, [hero]![K] L'Œuf...", german=" Oh, [hero]![K] Das Ei...", italian="Oh, [hero]![K] L'Uovo si\nsta...", spanish=" ¡Oh, [hero]![K] El Huevo..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, [hero]![K] The Egg is...", french=" Oh, [hero]![K] L'Œuf...", german=" Oh, [hero]![K] Das Ei...", italian="Oh, [hero]![K] L'Uovo si\nsta...", spanish=" ¡Oh, [hero]![K] El Huevo..."})
  else
  SkySceneKit.say({english=" Oh, [hero]![K] The Egg is...", french=" Oh, [hero]![K] L'Œuf...", german=" Oh, [hero]![K] Das Ei...", italian="Oh, [hero]![K] L'Uovo si\nsta...", spanish=" ¡Oh, [hero]![K] El Huevo..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's going to hatch!", french=" Il va éclore!", german=" Es schlüpft etwas aus dem Ei!", italian=" Si sta per schiudere!", spanish=" ¡Se está abriendo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It's hatching!", french=" Il va éclore!", german=" Es schlüpft!", italian=" Si sta per schiudere!", spanish=" ¡Se está abriendo!"})
  else
  SkySceneKit.say({english=" It's hatching!", french=" Il va éclore!", german=" Es schlüpft!", italian=" Si sta per schiudere!", spanish=" ¡Se está abriendo!"})
  end
  -- message_Close
  -- GAP: se_Play(7958) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(20) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(40)
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  GAME:WaitFrames(80)
  -- Destroy() [neutre/état moteur]
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  local npc_npc_manafi = SkySceneKit.spawn_npc("manaphy", 312, 184, Direction.Down, "NPC_MANAFI")
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" .........?", french=" .........?", german=" .........", italian=" .........?", spanish=" ¿?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Hi...iiii! ♪", french=" Hi... hiiiii! ♪", german=" Haaaalloooo! ♪", italian=" Ciaooooo...! ♪", spanish=" ¡Holaaaa! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- bgm_ChangeVolume(0,190) [volume BGM non scriptable en Lua PMDO: piste maintenue - documenté]
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Wow![K] It's a Pokémon, but I've\nnever seen anything like this!", french="Oh![K] C'est un Pokémon, mais je\nn'en ai jamais vu de pareil!", german="Wow![K] Es ist ein Pokémon, aber\nich habe so eins noch nie gesehen!", italian="Wow![K] È un Pokémon, ma è la\nprima volta che ne vedo uno così!", spanish="¡Mira![K] Es un Pokémon, ¡pero\nnunca había visto uno como este!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Wow![K] It's a Pokémon, but I've\nnever seen anything like this!", french="Oh![K] C'est un Pokémon, mais je\nn'en ai jamais vu de pareil!", german="Wow![K] Es ist ein Pokémon, aber\nich habe so eins noch nie gesehen!", italian="Wow![K] È un Pokémon, ma è la\nprima volta che ne vedo uno così!", spanish="¡Mira![K] Es un Pokémon, ¡pero\nnunca había visto uno como este!"})
  else
  SkySceneKit.say({english="Wow![K] It's a Pokémon, but not\nlike any I've seen before!", french="Oh![K] C'est un Pokémon, mais je\nn'en ai jamais vu de pareil!", german="Wow![K] Es ist ein Pokémon, aber\nich habe so eins noch nie gesehen!", italian="Wow![K] È un Pokémon, ma è la\nprima volta che ne vedo uno così!", spanish="¡Mira![K] Es un Pokémon, ¡pero\nnunca había visto uno como este!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, "happy", 1) end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Kyakya! ♪ Kyakya! ♪", french=" Aaagaaa! ♪ Kyaaakyaaa! ♪", german=" Kyakya! ♪ Kyakya! ♪", italian=" Kyakya! ♪ Kyakya! ♪", spanish=" ¡Kyakya! ♪ ¡Kyakya! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Ha! He's cute!", french=" Aaah! Qu'il est mignon!", german=" Oh! Wie niedlich!", italian=" Ah! Com'è carino!", spanish=" ¡Qué mono!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Ha! He's cute!", french=" Aaah! Qu'il est mignon!", german=" Oh! Wie niedlich!", italian=" Ah! Com'è carino!", spanish=" ¡Qué mono!"})
  else
  SkySceneKit.say({english=" Ha! What a cutie!", french=" Aaah! Qu'il est mignon!", german=" Oh! Wie niedlich!", italian=" Ah! Com'è carino!", spanish=" ¡Qué mono!"})
  end
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey, little guy.[K] What kind of\nPokémon are you?", french="Hé, petit.[K] Quel genre de\nPokémon es-tu?", german="Hey, kleines Kerlchen.[K] Was für\nein Pokémon bist du denn?", italian="Ehi, piccolo.[K] Che specie di\nPokémon sei?", spanish="Oye...[K] ¿Qué tipo de Pokémon\neres?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hey, little guy.[K] What kind of\nPokémon are you?", french="Hé, petit.[K] Quel genre de\nPokémon es-tu?", german="Hey, kleines Kerlchen.[K] Was für\nein Pokémon bist du denn?", italian="Ehi, piccolo.[K] Che specie di\nPokémon sei?", spanish="Oye...[K] ¿Qué tipo de Pokémon\neres?"})
  else
  SkySceneKit.say({english="Hi, little guy.[K] What kind of\nPokémon are you?", french="Hé, petit.[K] Quel genre de\nPokémon es-tu?", german="Hey, kleines Kerlchen.[K] Was für\nein Pokémon bist du denn?", italian="Ehi, piccolo.[K] Che specie di\nPokémon sei?", spanish="Oye...[K] ¿Qué tipo de Pokémon\neres?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" Poké?", french=" Poké?", german=" Poké?", italian=" Poké?", spanish=" ¿Poké?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I guess this little guy's too\nyoung to understand anything I say?", french="Il est probablement trop jeune\npour comprendre ce que je dis.", german="Ich vermute, das Kleine ist zu\njung, um irgendetwas von dem zu verstehen,\nwas ich sage.", italian="Immagino che sia troppo\npiccolo per capire cosa dico, giusto?", spanish="A lo mejor es demasiado pequeño\npara comprender lo que digo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Maybe this little guy's too young\nto understand anything I say?", french="Il est probablement trop jeune\npour comprendre ce que je dis.", german="Vielleicht ist das Kleine zu jung,\num etwas von dem zu verstehen, was ich sage.", italian="Immagino che sia troppo\npiccolo per capire cosa dico, giusto?", spanish="A lo mejor es demasiado pequeño\npara comprender lo que digo."})
  else
  SkySceneKit.say({english="Maybe this little guy's too young\nto understand anything I say?", french="Il est probablement trop jeune\npour comprendre ce que je dis.", german="Vielleicht ist das Kleine zu jung,\num etwas von dem zu verstehen, was ich sage.", italian="Immagino che sia troppo\npiccolo per capire cosa dico, giusto?", spanish="A lo mejor es demasiado pequeño\npara comprender lo que digo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_manafi) end)
  SkySceneKit.say({english=" I say?", french=" Jédi?", german=" Ich sage?", italian=" Dico?", spanish=" ¿Digo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Um... What should we do...?[K]\nI've never met a Pokémon like this little\nguy before.", french="Hum... que faire...?[K]\nJe n'ai jamais rencontré de Pokémon comme\nlui avant.", german="Ähm... Was sollen wir tun?[K]\nIch habe noch nie ein Pokémon von der Art\ndieses kleinen Kerlchens hier gesehen.", italian="Ehm... Cosa facciamo?[K]\nNon ho mai incontrato un Pokémon del genere.", spanish="Hum... ¿Qué hacemos?[K]\nNunca había visto un Pokémon así."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Um... What should we do...?[K]\nI've never had to deal with a Pokémon like this\nlittle guy before.", french="Hum... que faire...?[K]\nJe n'ai jamais rencontré de Pokémon comme\nlui avant.", german="Ähm... Was sollen wir tun?[K]\nBisher hatte ich noch nie mit einem Pokémon\nwie diesem kleinen Kerlchen zu tun.", italian="Ehm... Cosa facciamo?[K]\nNon ho mai incontrato un Pokémon del genere.", spanish="Hum... ¿Qué hacemos?[K]\nNunca había visto un Pokémon así."})
  else
  SkySceneKit.say({english="Um... What should we do...?[K]\nI've never had to deal with a Pokémon like this\nlittle guy before.", french="Hum... que faire...?[K]\nJe n'ai jamais rencontré de Pokémon comme\nlui avant.", german="Ähm... Was sollen wir tun?[K]\nBisher hatte ich noch nie mit einem Pokémon\nwie diesem kleinen Kerlchen zu tun.", italian="Ehm... Cosa facciamo?[K]\nNon ho mai incontrato un Pokémon del genere.", spanish="Hum... ¿Qué hacemos?[K]\nNunca había visto un Pokémon así."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hmmm...", french=" Hum...", german=" Hmmm...", italian=" Mmm...", spanish=" Hum..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hmmm...", french=" Hum...", german=" Hmmm...", italian=" Mmm...", spanish=" Hum..."})
  else
  SkySceneKit.say({english=" Hmmm...", french=" Hum...", german=" Hmmm...", italian=" Mmm...", spanish=" Hum..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Oh, I know![K] [CS:N]Chatot[CR] might know\nsomething! He's the guild's head of intelligence!", french="Oh, je sais![K] Demandons à [CS:N]Pijako[CR]!\nC'est le chef des renseignements à la Guilde!", german="Oh, ich weiß![K] [CS:N]Plaudagei[CR] könnte\nvielleicht etwas wissen! Er ist der\nInformationsleiter der Gilde!", italian="Oh, ci sono![K] [CS:N]Chatot[CR] potrebbe\nsapere qualcosa! Dopotutto è il gazzettino della\nGilda! Sa sempre tutto!", spanish="¡Ya sé![K] ¡[CS:N]Chatot[CR] podría saber\nalgo! ¡Maneja toda la información del\n[CS:N]Pokégremio[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Oh, I know![K] We should ask\n[CS:N]Chatot[CR]! He's the guild's head of intelligence!", french="Oh, je sais![K] Demandons à [CS:N]Pijako[CR]!\nC'est le chef des renseignements à la Guilde!", german="Oh, ich habe es![K] Wir sollten\n[CS:N]Plaudagei[CR] fragen! Er ist der Informationsleiter\nder Gilde!", italian="Oh, ci sono![K] [CS:N]Chatot[CR] potrebbe\nsapere qualcosa! Dopotutto è il gazzettino della\nGilda! Sa sempre tutto!", spanish="¡Ya sé![K] ¡[CS:N]Chatot[CR] podría saber\nalgo! ¡Maneja toda la información del\n[CS:N]Pokégremio[CR]!"})
  else
  SkySceneKit.say({english="Oh, I know![K] We should ask\n[CS:N]Chatot[CR]! He's the guild's head of intelligence!", french="Oh, je sais![K] Demandons à [CS:N]Pijako[CR]!\nC'est le chef des renseignements à la Guilde!", german="Oh, ich habe es![K] Wir sollten\n[CS:N]Plaudagei[CR] fragen! Er ist der Informationsleiter\nder Gilde!", italian="Oh, ci sono![K] [CS:N]Chatot[CR] potrebbe\nsapere qualcosa! Dopotutto è il gazzettino della\nGilda! Sa sempre tutto!", spanish="¡Ya sé![K] ¡[CS:N]Chatot[CR] podría saber\nalgo! ¡Maneja toda la información del\n[CS:N]Pokégremio[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's go see [CS:N]Chatot[CR],\n[hero]!", french="Allons voir [CS:N]Pijako[CR],\n[hero]!", german="Gehen wir zu [CS:N]Plaudagei[CR],\n[hero]!", italian="Andiamo da [CS:N]Chatot[CR],\n[hero]!", spanish="¡Vayamos a ver a [CS:N]Chatot[CR],\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Let's go see [CS:N]Chatot[CR],\n[hero]!", french="Allons voir [CS:N]Pijako[CR],\n[hero]!", german="Gehen wir zu [CS:N]Plaudagei[CR],\n[hero]!", italian="Andiamo da [CS:N]Chatot[CR],\n[hero]!", spanish="¡Vayamos a ver a [CS:N]Chatot[CR],\n[hero]!"})
  else
  SkySceneKit.say({english="Let's go see [CS:N]Chatot[CR],\n[hero]!", french="Allons voir [CS:N]Pijako[CR],\n[hero]!", german="Gehen wir zu [CS:N]Plaudagei[CR],\n[hero]!", italian="Andiamo da [CS:N]Chatot[CR],\n[hero]!", spanish="¡Vayamos a ver a [CS:N]Chatot[CR],\n[hero]!"})
  end
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(120) end)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 60)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitBgm
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
