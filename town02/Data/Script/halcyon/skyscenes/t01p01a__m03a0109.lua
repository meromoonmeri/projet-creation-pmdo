-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/m03a0109.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Treasure Town.ogg", true) end)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_T01P01A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(99) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_T01P01A, 'UM03') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:WaitFrames(1)
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That about covers it, I guess.", french=" Je crois qu'on a fait le tour.", german="Das wäre so ziemlich alles,\nglaube ich.", italian=" Mi sembra che non ci sia altro.", spanish=" Y creo que eso es todo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" And that should do it.", french=" Je crois qu'on a fait le tour.", german=" Das müsste reichen.", italian=" Mi sembra che non ci sia altro.", spanish=" Y creo que eso es todo."})
  else
  SkySceneKit.say({english=" I guess that about covers it.", french=" Je crois qu'on a fait le tour.", german="Ich glaube, das wäre so ziemlich\nalles.", italian=" Mi sembra che non ci sia altro.", spanish=" Creo que eso es todo."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 320, 216, Direction.Right, "NPC_BIPPA")
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="You sure know a lot, yes sirree!\nAnd that's good to know!", french="T'en sais des choses, pour sûr!\nC'est vachement bon à savoir!", german="Du weißt aber eine Menge, ja\nwirklich! Das ist gut zu wissen!", italian="Sai proprio un sacco di cose,\nsissignore! Mi fa piacere saperlo!", spanish="Sabes muchas cosas. ¡Sí, señor!\n¡Es estupendo!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="All right, then. Come find me\nwhen you're all ready to go.", french="Ben, venez m'voir quand z'aurez\nfini vos préparatifs.", german="Also gut. Kommt zu mir, bevor\nihr euch auf den Weg macht.", italian="Ok. Venite da me quando avete\nfinito.", spanish="De acuerdo. Venid a buscarme\ncuando lo tengáis todo listo para partir."})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="I'll give you a helping hand with\nselecting the right outlaw for you.", french="J'vous donnerai un coup\nd'main pour choisir un hors-la-loi\nà vot' portée.", german="Ich helfe euch dabei, den\nrichtigen Ganoven für euch zu finden.", italian="Vi darò una mano a scegliere\nun ricercato adatto al vostro livello.", spanish="Os ayudaré a escoger al\nmalhechor más adecuado para vuestro nivel."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Thanks, [CS:N]Bidoof[CR]. You've been\nreally nice about this.", french="Merci, [CS:N]Keunotor[CR]. C'était très\nsympa de ta part de nous faire visiter.", german="Danke, [CS:N]Bidiza[CR]. Das war wirklich\nnett von dir.", italian="Grazie, [CS:N]Bidoof[CR]. Sei stato molto\ngentile.", spanish="Gracias, [CS:N]Bidoof[CR].\nTe has portado muy bien con nosotros."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Thank you, [CS:N]Bidoof[CR]. You've been\nreally nice.", french="Merci, [CS:N]Keunotor[CR]. C'était très\nsympa de ta part de nous faire visiter.", german="Danke, [CS:N]Bidiza[CR]. Das war wirklich\nfreundlich von dir.", italian="Grazie, [CS:N]Bidoof[CR]. Sei stato molto\ngentile.", spanish="Gracias, [CS:N]Bidoof[CR].\nHas sido muy amable."})
  else
  SkySceneKit.say({english="Thank you. How nice of you,\n[CS:N]Bidoof[CR]!", french="Merci, [CS:N]Keunotor[CR]. C'était très\nsympa de ta part de nous faire visiter.", german="Vielen Dank. Das ist wirklich\nfreundlich von dir, [CS:N]Bidiza[CR]!", italian="Grazie, [CS:N]Bidoof[CR]. Sei stato molto\ngentile.", spanish="Gracias. Ha sido todo un detalle,\n[CS:N]Bidoof[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  SkySceneKit.spin(npc_npc_bippa, 4, 10, 3)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="G-golly, you're embarrassing me!\nAw, shucks...", french="Sapristi, tu vas m'faire rougir!\nSi c'est pas malheureux...", german="D-donnerwetter, ich bin ganz\nverlegen! Mannomann...", italian=" O-Ohibò, mi fai emozionare!", spanish="Va... vaya, ¡qué vergüenza!\n¡Tierra, trágame!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.spin(npc_npc_bippa, 4, 10, 4)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="I'll be waiting at the guild's\nupper underground floor for you.", french="J'vous attends au premier\nsous-sol d'la Guilde, hein.", german="Ich warte in der Unteren\nGildenebene 1 auf euch.", italian="Vi aspetterò al Piano inferiore\ndella Gilda 1.", spanish="Os estaré esperando en la planta -1\ndel [CS:N]Pokégremio[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_bippa, 352, 236, false, 2)
  GAME:WaitFrames(10)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(5)
  GROUND:EntTurn(hero, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(160), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(45)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" All right, let's go.", french=" On le rejoindra tout à l'heure.", german=" Alles klar, gehen wir.", italian=" Va bene, andiamo.", spanish=" De acuerdo, vamos."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" OK, let's go.", french=" On le rejoindra tout à l'heure.", german=" Okay, lass uns gehen.", italian=" Va bene, andiamo.", spanish=" De acuerdo, vamos."})
  else
  SkySceneKit.say({english=" OK, let's go.", french=" On le rejoindra tout à l'heure.", german=" Okay, lass uns gehen.", italian=" Va bene, andiamo.", spanish=" De acuerdo, vamos."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I'd like to see what kinds of\nitems are available!", french="J'aimerais bien aller voir quels\ngenres d'objets sont disponibles!", german="Ich würde gerne sehen, welche\nItems man kaufen kann!", italian="Vorrei vedere quali strumenti\nsono in vendita!", spanish="¡Quiero ver qué objetos\npodemos comprar!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'd like to see what kinds of\nitems are available!", french="J'aimerais bien aller voir quels\ngenres d'objets sont disponibles!", german="Ich würde gerne sehen, welche\nItems man kaufen kann!", italian="Vorrei vedere quali strumenti\nsono in vendita!", spanish="¡Quiero ver qué objetos\npodemos comprar!"})
  else
  SkySceneKit.say({english="I'd like to see what kinds of\nitems are available!", french="J'aimerais bien aller voir quels\ngenres d'objets sont disponibles!", german="Ich würde gerne sehen, welche\nItems man kaufen kann!", italian="Vorrei vedere quali strumenti\nsono in vendita!", spanish="¡Quiero ver qué objetos\npodemos comprar!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's go to the [CS:K]Kecleon[CR] Market!", french=" Allons au [CS:K]Marché Kecleon[CR]!", german=" Gehen wir zum [CS:K]Kecleon-Markt[CR]!", italian=" Andiamo al [CS:K]Kecleon[CR] Market!", spanish=" ¡Vámonos al [CS:K]Bazar Kecleon[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go to the [CS:K]Kecleon[CR] Market!", french=" Allons au [CS:K]Marché Kecleon[CR]!", german=" Gehen wir zum [CS:K]Kecleon-Markt[CR]!", italian=" Andiamo al [CS:K]Kecleon[CR] Market!", spanish=" ¡Vayamos al [CS:K]Bazar Kecleon[CR]!"})
  else
  SkySceneKit.say({english=" Let's go to the [CS:K]Kecleon[CR] Market!", french=" Allons au [CS:K]Marché Kecleon[CR]!", german=" Gehen wir zum [CS:K]Kecleon-Markt[CR]!", italian=" Andiamo al [CS:K]Kecleon[CR] Market!", spanish=" ¡Vamos al [CS:K]Bazar Kecleon[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Before we head back, a visit to\nthe [CS:K]Kecleon[CR] Market is a must!", french="Avant de rentrer, une visite au\n[CS:K]Marché Kecleon[CR] s'impose!", german="Bevor wir zurückgehen, müssen\nwir unbedingt zum [CS:K]Kecleon-Markt[CR]!", italian="Prima di tornare indietro, una\nvisita al [CS:K]Kecleon[CR] Market è d'obbligo!", spanish="Antes de volver, ¡tenemos\nque visitar el [CS:K]Bazar Kecleon[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Before we head back, a visit to\nthe [CS:K]Kecleon[CR] Market is a must!", french="Avant de rentrer, une visite au\n[CS:K]Marché Kecleon[CR] s'impose!", german="Bevor wir zurückgehen, müssen\nwir unbedingt zum [CS:K]Kecleon-Markt[CR]!", italian="Prima di tornare indietro, una\nvisita al [CS:K]Kecleon[CR] Market è d'obbligo!", spanish="Antes de volver, ¡tenemos\nque visitar el [CS:K]Bazar Kecleon[CR]!"})
  else
  SkySceneKit.say({english="Before we head back, a visit to\nthe [CS:K]Kecleon[CR] Market is a must!", french="Avant de rentrer, une visite au\n[CS:K]Marché Kecleon[CR] s'impose!", german="Bevor wir zurückgehen, müssen\nwir unbedingt zum [CS:K]Kecleon-Markt[CR]!", italian="Prima di tornare indietro, una\nvisita al [CS:K]Kecleon[CR] Market è d'obbligo!", spanish="Antes de volver, ¡tenemos\nque visitar el [CS:K]Bazar Kecleon[CR]!"})
  end
  -- message_Close
  SkySceneKit.cleanup_npcs()
end
