-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P17P02C/n02a0305.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_P17P02C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(42) [anim idle native]
  -- bgm2_PlayFadeIn(BGM_FIRE_CRACKLING3) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  GAME:WaitFrames(30)
  local npc_npc_pukurin_papa = SkySceneKit.spawn_npc("wigglytuff", 320, 208, Direction.Left, "NPC_PUKURIN_PAPA")
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english="I'm not sure what happened,\nand I still don't exactly know what it was...", french="Je ne sais pas exactement ce\nqui s'est passé ce jour-là, ni ce que j'ai vu...", german="Ich bin mir immer noch nicht\nsicher, was dort genau passiert ist...", italian="Non so bene cosa accadde\ne ancora adesso non riesco a darmi\nuna spiegazione...", spanish="No tengo claro qué sucedió y aún\nno sé cómo fue exactamente..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english="But I'm sure that it was\n[CS:Y]Igglybuff[CR] that saved me.", french="... mais je suis sûr d'une chose:\nc'est [CS:Y]Toudoudou[CR] qui m'a sauvé.", german="Aber ich bin mir sicher, dass\n[CS:Y]Fluffeluff[CR] mich gerettet hat.", italian="Ma sono sicuro che sia stato\n[CS:Y]Igglybuff[CR] a salvarmi.", spanish="Pero no me cabe duda de que fue\n[CS:Y]Igglybuff[CR] quien me salvó."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english=" Of that, I am certain.", french=" Oui, aucun doute là-dessus.", german=" Das weiß ich ganz genau.", italian=" Non ho dubbi su questo.", spanish=" De eso estoy seguro."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english="That kid has some kind of\nmysterious power.", french="Ce gamin possède un\npouvoir mystérieux.", german="Der Bengel hat eine sonderbare\nGabe oder so was Ähnliches.", italian="Quel bambino ha una specie\ndi potere misterioso.", spanish="Ese crío tiene algún tipo de\npoder misterioso."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english="He doesn't just have some\nstrong power.", french="Et il ne s'agit pas que d'une\nforce quelconque.", german="Es ist nicht einfach nur\neine Fähigkeit.", italian="Non si tratta solo di un potere\nmolto forte.", spanish=" No se trata solo de un gran don."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english="When people are in trouble...[K]\nThat's when it appears...", french="Quand quelqu'un se trouve en\ndifficulté...[K] C'est là que ça se manifeste...", german="Sobald jemand gefährdet ist,[K]\nkommt die Gabe zum Vorschein...", italian="È qualcosa che si manifesta...[K]\nquando la gente è in pericolo...", spanish="Es algo que se manifiesta...[K]\ncuando alguien está en apuros..."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english="I get the feeling this power is\nfull of his kindness for others.", french="J'ai l'impression que ce pouvoir\npuise sa force dans les bons sentiments que\nnotre fils éprouve envers les autres.", german="Ich habe so eine Ahnung, dass\ndiese Gabe seiner unermesslichen Güte\ngegenüber allen anderen Wesen entspringt.", italian="Ho la sensazione che questo\npotere sia una manifestazione della\nsua bontà nei confronti degli altri.", spanish="Me da la impresión de que ese don\nlo forma su bondad hacia los demás."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english="I understand your concerns,\n[CS:N]Mama[CR]...[K] But I think we should trust our\nchild a little more, OK?", french="Je comprends que tu t'inquiètes,\n[CS:N]Maman[CR]...[K] Mais je crois que nous devrions\nlui faire un peu plus confiance, d'accord?", german="Ich verstehe deine Sorgen gut,\n[CS:N]Mama[CR]...[K] Aber ich denke, wir sollten unserem\nKind etwas mehr vertrauen, nicht wahr?", italian="Capisco che tu sia preoccupata,\n[CS:N]mamma[CR]...[K] ma penso che dovremmo fidarci\nun po' di più di nostro figlio, ok?", spanish="Entiendo lo que te preocupa, cariño,[K]\npero creo que deberíamos confiar un poco más\nen nuestro pequeñín, ¿no crees?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(3, -5) [neutre/état moteur]
  local npc_npc_pukurin_mama = SkySceneKit.spawn_npc("wigglytuff", 256, 208, Direction.UpLeft, "NPC_PUKURIN_MAMA")
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english=" ...[K]Yes.[K] You're right...", french=" ...[K] Oui.[K] Tu as sans doute raison...", german=" ...[K]Ja.[K] Du hast recht...", italian=" ...[K] Sì.[K] Hai ragione.", spanish=" Hum...[K] Sí.[K] Tienes razón..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GROUND:EntTurn(npc_npc_pukurin_mama, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  -- message_FacePositionOffset(3, -5) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english=" I'm sorry, [CS:N]Papa[CR].", french=" Excuse-moi, [CS:N]Papa[CR].", german=" Es tut mir leid, [CS:N]Papa[CR].", italian=" Scusami, [CS:N]papà[CR].", spanish=" Me dejas mucho más tranquila."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english="He'll be OK.[K] After all, he is\nour son. ♪", french="Tout ira bien pour lui.[K]\nC'est notre fils, après tout. ♪", german="Es wird ihm schon gut gehen.[K]\nImmerhin ist er unser Sohn. ♪", italian="Andrà tutto bene.[K] Dopotutto,\nè pur sempre nostro figlio. ♪", spanish="No le va a pasar nada.[K] Al fin y\nal cabo, es nuestro hijo. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english=" Yeah.", french=" Eh oui.", german=" Ja.", italian=" Già.", spanish=" Ya."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english="It's a good thing to be concerned\nabout, [CS:N]Mama[CR], so don't worry.", french="C'est bien naturel que tu\nt'inquiètes pour lui, [CS:N]Maman[CR],\net c'est une bonne chose.", german="Es ist gut, besorgt zu sein,\n[CS:N]Mama[CR], also sei nicht betrübt.", italian="È un bene che tu voglia\nprenderti cura di lui, [CS:N]mamma[CR],\nquindi non preoccuparti.", spanish="Es normal que te preocupen\neste tipo de cosas."})
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_papa) end)
  SkySceneKit.say({english="That is, the fact that you are\nconcerned, [CS:N]Mama[CR]...[K] It just shows how much\nyou truly care about [CS:Y]Igglybuff[CR]...[K]right?", french="Que tu t'inquiètes comme ça,\n[CS:N]Maman[CR]...[K] ça montre juste à quel point\ntu tiens à notre [CS:Y]Toudoudou[CR]...[K] pas vrai?", german="Dass du dir Sorgen machst,\n[CS:N]Mama[CR]...[K] Das zeigt doch nur, wie gern du den\nkleinen [CS:Y]Fluffeluff[CR] hast...[K] Nicht wahr?", italian="D'altronde il fatto che tu sia\ncosì preoccupata...[K] è solo un segno del\nbene che vuoi a [CS:Y]Igglybuff[CR]...[K] giusto?", spanish="El hecho de que te preocupes...[K] no hace\nmás que demostrar cuánto te importa\n[CS:Y]Igglybuff[CR],[K] ¿no crees?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(3, -5) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_pukurin_mama) end)
  SkySceneKit.say({english=" Yeah.[K] Thank you, [CS:N]Papa[CR]. ♪", french=" Oui.[K] Merci, [CS:N]Papa[CR]. ♪", german="Ja, das stimmt.[K] Danke schön,\ndu hast mich beruhigt, [CS:N]Papa[CR]. ♪", italian=" È vero.[K] Grazie, [CS:N]papà[CR]. ♪", spanish=" Es cierto.[K] Gracias, cariño. ♪"})
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(160) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(60)
  SkySceneKit.cleanup_npcs()
end
