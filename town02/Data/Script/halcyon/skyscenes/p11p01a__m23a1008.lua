-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P11P01A/m23a1008.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_P11P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_rapurasu = SkySceneKit.spawn_npc("lapras", 96, 272, Direction.Right, "NPC_RAPURASU")
  -- ResetOutputAttribute(256) [neutre/état moteur]
  -- GAP: SetEffect 664 — VFX sans émote PMDO équivalente
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_rapurasu, 188, 272, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" [partner]... [hero]...", french=" [partner]... [hero]...", german=" [partner]... [hero]...", italian=" [partner]... [hero]...", spanish=" [partner]... [hero]..."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" and [CS:N]Grovyle[CR]...correct?", french=" ... et [CS:N]Massko[CR], si je ne m'abuse.", german=" Und [CS:N]Reptain[CR]... Korrekt?", italian=" ... e [CS:N]Grovyle[CR], giusto?", spanish=" Y [CS:N]Grovyle[CR]. ¿Me equivoco?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 272, 264, Direction.Left, "NPC_JUPUTORU")
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" You know our names?", french=" Tu connais nos noms?", german=" Du kennst unsere Namen?", italian=" Conosci i nostri nomi?", spanish=" ¿Sabes cómo nos llamamos?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" You know our names?", french=" Tu connais nos noms?", german=" Du kennst unsere Namen?", italian=" Conosci i nostri nomi?", spanish=" ¿Sabes cómo nos llamamos?"})
  else
  SkySceneKit.say({english=" You know our names?", french=" Tu connais nos noms?", german=" Du kennst unsere Namen?", italian=" Conosci i nostri nomi?", spanish=" ¿Sabes cómo nos llamamos?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" Yes.", french=" En effet.", german=" Ja.", italian=" Sì.", spanish=" Sí."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" I was informed by [CS:N]Wigglytuff[CR].", french=" [CS:N]Grodoudou[CR] m'a mis au courant.", german="Ich wurde von [CS:N]Knuddeluff[CR]\ninformiert.", italian=" Me li ha detti [CS:N]Wigglytuff[CR].", spanish=" [CS:N]Wigglytuff[CR] me ha informado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]W-Wigglytuff[CR] told you?", french=" [CS:N]G-Grodoudou[CR] t'a raconté?", german="[CS:N]K-Knuddeluff[CR] hat sie dir\ngenannt?", italian=" Te li ha detti [CS:N]W-Wigglytuff[CR]?", spanish=" ¿[CS:N]Wigglytuff[CR] te lo ha dicho?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]W-Wigglytuff[CR] told you?", french=" [CS:N]G-Grodoudou[CR] t'a raconté?", german="[CS:N]K-Knuddeluff[CR] hat sie dir\ngenannt?", italian=" Te li ha detti [CS:N]W-Wigglytuff[CR]?", spanish=" ¿[CS:N]Wigglytuff[CR] te lo ha dicho?"})
  else
  SkySceneKit.say({english=" [CS:N]W-Wigglytuff[CR] told you?", french=" [CS:N]G-Grodoudou[CR] t'a raconté?", german="[CS:N]K-Knuddeluff[CR] hat sie dir\ngenannt?", italian=" Te li ha detti [CS:N]W-Wigglytuff[CR]?", spanish=" ¿[CS:N]Wigglytuff[CR] te lo ha dicho?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="That pattern on the wall shot a\nbeam of light across the sea.", french="Ce symbole a émis un rayon\nde lumière en direction de la mer.", german="Dieses Muster an der Wand hat\neinen Lichtkegel geworfen, der über das Meer\nfiel.", italian="Quel disegno sul muro ha\nproiettato un raggio di luce oltre il mare.", spanish="Has aparecido justo después de\nque el símbolo emitiera esa especie de rayo\nde luz hacia el mar."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="That pattern on the wall shot a\nbeam of light across the sea.", french="Ce symbole a émis un rayon\nde lumière en direction de la mer.", german="Dieses Muster an der Wand hat\neinen Lichtkegel geworfen, der über das Meer\nfiel.", italian="Quel disegno sul muro ha\nproiettato un raggio di luce oltre il mare.", spanish="Has aparecido justo después de\nque el símbolo emitiera esa especie de rayo\nde luz hacia el mar."})
  else
  SkySceneKit.say({english="That pattern on the wall shot a\nbeam of light across the sea.", french="Ce symbole a émis un rayon\nde lumière en direction de la mer.", german="Dieses Muster an der Wand hat\neinen Lichtkegel geworfen, der über das Meer\nfiel.", italian="Quel disegno sul muro ha\nproiettato un raggio di luce oltre il mare.", spanish="Has aparecido justo después de\nque el símbolo emitiera esa especie de rayo\nde luz hacia el mar."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" You appeared right after that.", french=" Et tu es apparu juste après ça.", german=" Direkt danach bist du erschienen.", italian=" E subito dopo sei apparso tu.", spanish=" Como si te hubiera llamado..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" You appeared right after that.", french=" Et tu es apparu juste après ça.", german=" Direkt danach bist du erschienen.", italian=" E subito dopo sei apparso tu.", spanish=" Como si te hubiera llamado..."})
  else
  SkySceneKit.say({english=" And then you appeared.", french=" Et tu es apparu juste après ça.", german=" Direkt danach bist du erschienen.", italian=" E dopo sei arrivato tu.", spanish=" Como si te hubiera llamado..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Can you tell me who you are?", french=" On peut savoir qui tu es?", german="Kannst du mir sagen, wer du\nbist?", italian=" Puoi dirmi chi sei?", spanish=" ¿Quién eres?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Can you tell me who you are?", french=" On peut savoir qui tu es?", german="Kannst du mir sagen, wer du\nbist?", italian=" Puoi dirmi chi sei?", spanish=" ¿Quién eres?"})
  else
  SkySceneKit.say({english=" Can you tell me who you are?", french=" On peut savoir qui tu es?", german="Kannst du mir sagen, wer du\nbist?", italian=" Puoi dirmi chi sei?", spanish=" ¿Quién eres?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="I'm [CS:N]Lapras[CR].[K] I am the guide to the\n[CS:P]Hidden Land[CR].", french="Je m'appelle [CS:N]Lokhlass[CR].[K]\nLe passeur des [CS:P]Terres Illusoires[CR].", german="Ich bin [CS:N]Lapras[CR].[K] Ich geleite euch\nzum [CS:P]Verborgenen Land[CR].", italian="Sono [CS:N]Lapras[CR].[K] Sono la guida\nper la [CS:P]Terra Nascosta[CR].", spanish="Soy [CS:N]Lapras[CR].[K]\nOs guiaré a la [CS:P]Tierra Oculta[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_juputoru, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You're serious?![K] You can take us\nto the [CS:P]Hidden Land[CR]?!", french="Tu es sérieux?![K] Tu peux nous\nconduire jusqu'aux [CS:P]Terres Illusoires[CR]?!", german="Meinst du das ernst?[K] Du kannst\nuns zum [CS:P]Verborgenen Land[CR] bringen?!?", italian="Dici sul serio?![K] Ci puoi portare\nalla [CS:P]Terra Nascosta[CR]?!", spanish="¡¿En serio?![K] ¡¿Nos puedes\nllevar a la [CS:P]Tierra Oculta[CR]?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You're what?![K] You can take us\nto the [CS:P]Hidden Land[CR]?!", french="Tu es sérieux?![K] Tu peux nous\nconduire jusqu'aux [CS:P]Terres Illusoires[CR]?!", german="Meinst du das ernst?[K] Du kannst\nuns zum [CS:P]Verborgenen Land[CR] bringen?!?", italian="Che cosa?![K] Ci puoi portare alla\n[CS:P]Terra Nascosta[CR]?!", spanish="¡¿En serio?![K] ¡¿Nos puedes\nllevar a la [CS:P]Tierra Oculta[CR]?!"})
  else
  SkySceneKit.say({english="You're what?![K] You can take us\nto the [CS:P]Hidden Land[CR]?!", french="Tu es sérieux?![K] Tu peux nous\nconduire jusqu'aux [CS:P]Terres Illusoires[CR]?!", german="Meinst du das ernst?[K] Du kannst\nuns zum [CS:P]Verborgenen Land[CR] bringen?!?", italian="Che cosa?![K] Ci puoi portare alla\n[CS:P]Terra Nascosta[CR]?!", spanish="¡¿En serio?![K] ¡¿Nos puedes\nllevar a la [CS:P]Tierra Oculta[CR]?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -3) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="You unleashed the beam of light\nfrom the pattern on the wall.", french="Vous avez déclenché\nle Lokh-Signal.", german="Ihr habt den Lichtkegel aus dem\nMuster an der Wand entfesselt.", italian="Avete liberato il raggio di luce\ndal disegno sul muro.", spanish="El rayo de luz que habéis\nlogrado emitir activando el símbolo..."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="That is the signal for gaining\nentry to the [CS:P]Hidden Land[CR].", french="C'est le signal qui permet d'avoir\naccès aux [CS:P]Terres Illusoires[CR].", german="Das ist das Signal, um Einlass\nzum [CS:P]Verborgenen Land[CR] zu erhalten.", italian="In questo modo vi siete\nguadagnati il diritto di accedere alla\n[CS:P]Terra Nascosta[CR].", spanish="Es la señal que permite\nla entrada a la [CS:P]Tierra Oculta[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english=" It is beyond the sea.", french="Elles se trouvent de l'autre côté\nde la mer.", german=" Es liegt jenseits des Meeres.", italian=" È oltre il mare.", spanish="La [CS:P]Tierra Oculta[CR] está más allá\ndel mar."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="Step onto my back.[K] I will\ncarry you across the sea.", french="Montez sur mon dos.[K] Je vais\nvous porter pendant la traversée.", german="Steigt auf meinen Rücken.[K]\nIch werde euch über das Meer bringen.", italian="Salitemi in groppa.[K] Vi porterò\nal di là del mare.", spanish="Poneos sobre mi espalda.[K]\nOs llevaré hasta allí."})
  pcall(function() UI:SetSpeaker(npc_npc_rapurasu) end)
  SkySceneKit.say({english="Don't be afraid.[K] I'm exceptional.\nI can carry you all and more on my back.", french="N'ayez pas peur.[K]\nJ'ai des pouvoirs exceptionnels. Je peux tous\nvous porter sans problème.", german="Fürchtet euch nicht.[K] Ich bin\naußergewöhnlich. Ich kann euch alle und noch\nmehr auf meinem Rücken tragen.", italian="Non abbiate paura.[K] Sono\nforte. Posso portare su di me anche\npiù di tre Pokémon.", spanish="No temáis.[K] No soy un Pokémon\ncorriente. Puedo cargar con mucho más de lo\nque creéis."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GROUND:EntTurn(npc_npc_juputoru, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's beyond the sea...[K]\nThe [CS:P]Hidden Land[CR].", french="Alors de l'autre côté de la\nmer...[K] se trouvent les [CS:P]Terres Illusoires[CR].", german="Es liegt jenseits des Meeres...[K]\nDas [CS:P]Verborgene Land[CR].", italian="La [CS:P]Terra Nascosta[CR]...[K]\nè al di là del mare.", spanish="Más allá del mar nos espera...[K]\nla [CS:P]Tierra Oculta[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's beyond the sea...[K]\nThe [CS:P]Hidden Land[CR].", french="Alors de l'autre côté de la\nmer...[K] se trouvent les [CS:P]Terres Illusoires[CR].", german="Es liegt jenseits des Meeres...[K]\nDas [CS:P]Verborgene Land[CR].", italian="La [CS:P]Terra Nascosta[CR]...[K]\nè al di là del mare.", spanish="Más allá del mar nos espera...[K]\nla [CS:P]Tierra Oculta[CR]."})
  else
  SkySceneKit.say({english="It's beyond the sea...[K]\nThe [CS:P]Hidden Land[CR].", french="Alors de l'autre côté de la\nmer...[K] se trouvent les [CS:P]Terres Illusoires[CR].", german="Es liegt jenseits des Meeres...[K]\nDas [CS:P]Verborgene Land[CR].", italian="La [CS:P]Terra Nascosta[CR]...[K]\nè al di là del mare.", spanish="Más allá del mar nos espera...[K]\nla [CS:P]Tierra Oculta[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" [hero]! [partner]!", french=" [hero]! [partner]!", german=" [hero]! [partner]!", italian=" [hero]! [partner]!", spanish=" ¡[hero]! ¡[partner]!"})
  pcall(function() UI:SetSpeaker(npc_npc_juputoru) end)
  SkySceneKit.say({english=" Let's go![K] Beyond the sea!", french=" C'est parti![K] Traversons la mer!", german=" Gehen wir![K] Über das Meer!", italian=" Andiamo![K] Al di là del mare!", spanish="¡Vamos allá![K]\n¡Al otro lado del mar!"})
  -- message_Close
  -- SetAnimation(71) [anim idle native]
  -- SetAnimation(71) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(45)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 60)
  GAME:WaitFrames(60)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  SkyProg.set(25, 0) -- $SCENARIO_MAIN = scn[25,0] (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
