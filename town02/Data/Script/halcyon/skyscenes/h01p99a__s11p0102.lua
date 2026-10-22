-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99A/s11p0102.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_H01P99A) [neutre/état moteur]
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_IS_RECURITABLE_IN_TEAM"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_IS_RECURITABLE_IN_T) [ProcessSpecial(PROCESS_SPECIAL_IS_RECURITABLE_IN_TEAM): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(10)
  local npc_npc_manafi = SkySceneKit.spawn_npc("manaphy", 368, 200, Direction.Left, "NPC_MANAFI")
  GROUND:EntTurn(npc_npc_manafi, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_manafi, "exclaim", 1) end)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(24), p.Y+(0), false, 2) end
  GAME:WaitFrames(15)
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(10)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(24), p.Y+(0), false, 2) end
  GROUND:MoveToPosition(hero, 316, 204, false, 2)
  GROUND:MoveToPosition(partner, 316, 180, false, 2)
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_manafi, Direction.Left)
  GROUND:EntTurn(hero, Direction.Right)
  GROUND:EntTurn(partner, Direction.Right)
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[c_name:NPC_MANAFI]: Hi, [hero] and\n[partner]!", french="[c_name:NPC_MANAFI]: Bonjour, [hero] et\n[partner]!", german="[c_name:NPC_MANAFI]: Hallo, [hero] und\n[partner]!", italian="[c_name:NPC_MANAFI]: Ciao, [hero] e\n[partner]!", spanish="[c_name:NPC_MANAFI]: ¡Hola, [hero] y\n[partner]!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[c_name:NPC_MANAFI]: Good morning!", french="[c_name:NPC_MANAFI]: Belle journée!", german="[c_name:NPC_MANAFI]: Guten Morgen!", italian="[c_name:NPC_MANAFI]: Buongiorno!", spanish="[c_name:NPC_MANAFI]: ¡Buenos días!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Hey, it's [c_name:NPC_MANAFI]!\nGood morning to you!", french=" Hé, c'est [c_name:NPC_MANAFI]! Bonjour!", german="Hey, es ist [c_name:NPC_MANAFI]!\nGuten Morgen!", italian="Ehi, è [c_name:NPC_MANAFI]! Buongiorno\na te!", spanish="¡Hombre, pero si es\n[c_name:NPC_MANAFI]! ¡Buenos días!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hey, it's [c_name:NPC_MANAFI]!\nGood morning!", french=" Hé, c'est [c_name:NPC_MANAFI]! Bonjour!", german="Hey, es ist [c_name:NPC_MANAFI]!\nGuten Morgen!", italian="Ehi, è [c_name:NPC_MANAFI]! Buongiorno\na te!", spanish="¡Hombre, pero si es\n[c_name:NPC_MANAFI]! ¡Buenos días!"})
  else
  SkySceneKit.say({english="Hey, it's [c_name:NPC_MANAFI]!\nGood morning!", french=" Hé, c'est [c_name:NPC_MANAFI]! Bonjour!", german="Hey, es ist [c_name:NPC_MANAFI]!\nGuten Morgen!", italian="Ehi, è [c_name:NPC_MANAFI]! Buongiorno\na te!", spanish="¡Hombre, pero si es\n[c_name:NPC_MANAFI]! ¡Buenos días!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="What brings you back here so\nearly in the morning?", french="Qu'est-ce que tu fais là de si\nbon matin?", german="Was bringt dich denn so früh\nam Morgen zu uns?", italian="Cosa ci fai qui a quest'ora\ndella mattina?", spanish="¿Qué te trae por aquí tan\ntemprano?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="What brings you back here so\nearly in the morning!", french="Qu'est-ce que tu fais là de si\nbon matin?", german="Was bringt dich denn so früh\nam Morgen zu uns?", italian="Cosa ci fai qui a quest'ora\ndella mattina?", spanish="¿Qué te trae por aquí tan\ntemprano?"})
  else
  SkySceneKit.say({english="What brings you back here so\nearly in the morning!", french="Qu'est-ce que tu fais là de si\nbon matin?", german="Was bringt dich denn so früh\nam Morgen zu uns?", italian="Cosa ci fai qui a quest'ora\ndella mattina?", spanish="¿Qué te trae por aquí tan\ntemprano?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_2") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[c_name:NPC_MANAFI]: Well, um, I was on my daily\nmorning travels...", french="[c_name:NPC_MANAFI]: Eh bien, en faisant mon\nexploration matinale, comme tous les jours...", german="[c_name:NPC_MANAFI]: Nun ja, ähem, ich bin gerade auf\nmeinem täglichen Morgenausflug unterwegs...", italian="[c_name:NPC_MANAFI]: Beh, ehm, stavo facendo il mio\nsolito viaggio mattutino...", spanish="[c_name:NPC_MANAFI]: Bueno, estaba dando mi paseo\nmatutino..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[c_name:NPC_MANAFI]: And I found a really great place!", french="[c_name:NPC_MANAFI]: ... j'ai trouvé un endroit\ndu tonnerre!", german="[c_name:NPC_MANAFI]: Und ich habe einen echt tollen\nOrt gefunden!", italian="[c_name:NPC_MANAFI]: E ho trovato un posto\ndavvero fantastico!", spanish="[c_name:NPC_MANAFI]: ¡Y he descubierto un sitio genial!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" A really great place?", french=" Vraiment?", german=" Einen echt tollen Ort?", italian=" Un posto davvero fantastico?", spanish=" ¿Un sitio genial?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" A really great place?", french=" Vraiment?", german=" Einen echt tollen Ort?", italian=" Un posto davvero fantastico?", spanish=" ¿Un sitio genial?"})
  else
  SkySceneKit.say({english=" A really great place?", french=" Vraiment?", german=" Einen echt tollen Ort?", italian=" Un posto davvero fantastico?", spanish=" ¿Un sitio genial?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[c_name:NPC_MANAFI]: Yep, yep! It has crystal clear\nwater and a white-sand beach...", french="[c_name:NPC_MANAFI]: Oui, oui! Avec de l'eau limpide\net des plages de sable blanc...", german="[c_name:NPC_MANAFI]: Jep, jep! Dort gibt es\nkristallklares Wasser und einen weißen\nSandstrand...", italian="[c_name:NPC_MANAFI]: Proprio così! L'acqua è\ncristallina e la spiaggia è fatta di\nsabbia bianca...", spanish="[c_name:NPC_MANAFI]: ¡Sí! Tiene agua cristalina y una\nplaya de arena blanca..."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[c_name:NPC_MANAFI]: And it's got plenty of totally\nyummi Gummis!", french="[c_name:NPC_MANAFI]: ... et des tas de délicieuses\ngelées!", german="[c_name:NPC_MANAFI]: Und auch noch viele leckere\nGummibonbons!", italian="[c_name:NPC_MANAFI]: Ed è pieno di Caramelle\nGommose assolutamente deliziose!", spanish="[c_name:NPC_MANAFI]: ¡Y hay gomis por todas partes!"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[c_name:NPC_MANAFI]: And the place is named the\n[CS:P]Marine Resort[CR]! It's a Pokémon paradise!", french="[c_name:NPC_MANAFI]: Ça s'appelle la [CS:P]Station Marine[CR]!\nC'est un paradis pour les Pokémon!", german="[c_name:NPC_MANAFI]: Der Ort heißt [CS:P]Meereszuflucht[CR]!\nEs ist ein Paradies für Pokémon!", italian="[c_name:NPC_MANAFI]: Si chiama\n[CS:P]Riserva Marina[CR]! È un paradiso per Pokémon!", spanish="[c_name:NPC_MANAFI]: ¡El lugar en cuestión se llama\n[CS:P]Refugio Marino[CR]! ¡Es un paraíso!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The [CS:P]Marine Resort[CR]![K]\nA Pokémon paradise?!", french="La [CS:P]Station Marine[CR]![K] Un\nparadis pour les Pokémon?!", german="Die [CS:P]Meereszuflucht[CR]![K] Ein Paradies\nfür Pokémon?!?", italian="La [CS:P]Riserva Marina[CR]![K] Un paradiso\nper Pokémon?!", spanish="¡El [CS:P]Refugio Marino[CR]![K]\n¿Un paraíso?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The [CS:P]Marine Resort[CR]![K]\nA Pokémon paradise?!", french="La [CS:P]Station Marine[CR]![K] Un\nparadis pour les Pokémon?!", german="Die [CS:P]Meereszuflucht[CR]![K] Ein Paradies\nfür Pokémon?!?", italian="La [CS:P]Riserva Marina[CR]![K] Un paradiso\nper Pokémon?!", spanish="¡El [CS:P]Refugio Marino[CR]![K]\n¿Un paraíso?"})
  else
  SkySceneKit.say({english="The [CS:P]Marine Resort[CR]![K]\nA Pokémon paradise?!", french="La [CS:P]Station Marine[CR]![K] Un\nparadis pour les Pokémon?!", german="Die [CS:P]Meereszuflucht[CR]![K] Ein Paradies\nfür Pokémon?!?", italian="La [CS:P]Riserva Marina[CR]![K] Un paradiso\nper Pokémon?!", spanish="¡El [CS:P]Refugio Marino[CR]![K]\n¿Un paraíso?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[c_name:NPC_MANAFI]: I couldn't wait to come tell you\nand [hero] right away.", french="[c_name:NPC_MANAFI]: Je voulais absolument vous\nen parler tout de suite.", german="[c_name:NPC_MANAFI]: Ich konnte es nicht erwarten,\ndir und [hero] sofort davon\nzu berichten.", italian="[c_name:NPC_MANAFI]: Non ho resistito, quindi sono\ncorso a dirlo a te e a [hero].", spanish="[c_name:NPC_MANAFI]: Me moría de ganas de venir\na contároslo a ti y a [hero]."})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[c_name:NPC_MANAFI]: So I cut my daily trip short\nand came straight here to tell you!", french="[c_name:NPC_MANAFI]: Alors j'ai écourté mon voyage\net je suis venu directement!", german="[c_name:NPC_MANAFI]: Also habe ich meinen täglichen\nAusflug etwas verkürzt und bin sofort zu euch\ngekommen, um es euch mitzuteilen!", italian="[c_name:NPC_MANAFI]: Così ho accorciato il mio viaggio\nquotidiano e sono venuto a dirvelo!", spanish="[c_name:NPC_MANAFI]: ¡Así que he acortado mi paseo\ndiario para venir a contároslo!"})
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[c_name:NPC_MANAFI]: I'll show you where it is.\nCan you open your map for me?", french="[c_name:NPC_MANAFI]: Je vais vous montrer où c'est.\nVous pouvez déplier votre carte?", german="[c_name:NPC_MANAFI]: Ich zeige euch, wo es ist.\nKönnt ihr eure Karte für mich aufschlagen?", italian="[c_name:NPC_MANAFI]: Vi mostro dove si trova.\nPotete aprire la Mappa un attimo?", spanish="[c_name:NPC_MANAFI]: Os enseñaré dónde es.\n¿Podéis abrir vuestro mapa?"})
  -- message_Close
  -- GAP: se_Play(6667) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 30)
  -- worldmap_SetMode(4) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- back2_SetMode(3) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- worldmap_SetCamera(73) [carte du monde 2e écran NDS: information de progression, gérée par les menus PMDO - documenté]
  -- worldmap_SetArrow(73) [flèche carte du monde: UI moteur NDS - équivalent géré par le menu voyage PMDO]
  -- worldmap_BlinkMark(73) [neutre/état moteur]
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayFanfare("Fanfare/NewArea") end) -- me_Play(6) [jingle ME NDS -> fanfare PMDO]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[CN]You can now go to\n[CN]the [CS:P]Marine Resort[CR]!", french="[CN]Désormais, vous pouvez accéder\n[CN]à la [CS:P]Station Marine[CR]!", german="[CN]Du kannst jetzt zur\n[CN][CS:P]Meereszuflucht[CR] gehen!", italian="[CN]Adesso potete andare\n[CN]alla [CS:P]Riserva Marina[CR]!", spanish="[CN]¡Ahora puedes ir\n[CN]al [CS:P]Refugio Marino[CR]!"})
  GAME:WaitFrames(2) -- join WaitMe
  -- message_Close
  -- screen2_FadeOut [sub déjà caché]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[c_name:NPC_MANAFI]: Let's go play there\ntogether sometime!", french="[c_name:NPC_MANAFI]: Allons nous y amuser ensemble\nde temps en temps!", german="[c_name:NPC_MANAFI]: Lasst uns dort mal zusammen\nspielen!", italian="[c_name:NPC_MANAFI]: Possiamo andarci a giocare\ninsieme qualche volta!", spanish="[c_name:NPC_MANAFI]: ¡Vayamos juntos algún día\na disfrutar de la vista!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Yup, yup!", french=" Oh oui!", german=" Ja, ja!", italian=" Certo!", spanish=" ¡Sí!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Of course!", french=" Oh oui!", german=" Natürlich!", italian=" Certo!", spanish=" ¡Claro!"})
  else
  SkySceneKit.say({english=" Yep, yep!", french=" Oh oui!", german=" Ja, ja!", italian=" Certo!", spanish=" ¡Sí!"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="[c_name:NPC_MANAFI]: OK, bye!", french="[c_name:NPC_MANAFI]: D'accord, à plus tard!", german="[c_name:NPC_MANAFI]: Okay, tschüss!", italian="[c_name:NPC_MANAFI]: Ok, ciao!", spanish="[c_name:NPC_MANAFI]: ¡Vale, adiós!"})
  -- message_Close
  do local p=npc_npc_manafi.Position; GROUND:MoveToPosition(npc_npc_manafi, p.X+(160), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 30)
  GAME:WaitFrames(90)
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  elseif true then -- default
  -- supervision_LoadStation(LEVEL_H01P99A, 'US23') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  SkySceneKit.cleanup_npcs()
end
