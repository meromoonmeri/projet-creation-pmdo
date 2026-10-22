-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D08P11A/m09a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(10, 1) -- $SCENARIO_MAIN = scn[10,1] (ROM)
  -- back_SetBanner2(LEVEL_V09P01A, 0, 160, 120, 8,) [bannière 2e écran NDS: information dupliquée du menu, hors canvas unique - documenté]
  GAME:FadeIn(45)
  GAME:WaitFrames(160)
  GAME:FadeOut(false, 45)
  GAME:WaitFrames(15)
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 296, 640, Direction.Up, "NPC_BIPPA")
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Huff-huff...", french=" Pff, pff...", german=" Keuch, keuch...", italian=" Uff-uff...", spanish=" ¡Ay!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="W-we did it! We got over\n[CS:P]Mt. Horn[CR]!", french="On a réussi! On a vaincu le\n[CS:P]Mt Corne[CR]!", german="W-wir haben es geschafft! Wir\nsind über den [CS:P]Hornberg[CR] gekommen!", italian="C-Ce l'abbiamo fatta! Abbiamo\nsuperato il [CS:P]Monte Aguzzo[CR]!", spanish="¡Lo conseguimos! ¡Hemos\nsuperado el [CS:P]Monte Cuerno[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="We finally made it! Yes sirree!\nWe have arrived at the base camp!", french="On a enfin réussi! Sapristi!\nV'là l'camp d'base!", german="Endlich geschafft! Jawollja!\nWir haben das Basislager erreicht!", italian="Finalmente ce l'abbiamo fatta!\nSiamo arrivati al Campo Base!", spanish="¡Lo hemos logrado! ¡Sí, señor!\n¡Hemos llegado al campamento base!"})
  -- message_Close
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D08P11A) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_D08P11A, 'UM09') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 296, 472, Direction.Up, "NPC_PERAPPU")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  local npc_npc_pukurin = SkySceneKit.spawn_npc("wigglytuff", 336, 360, Direction.Down, "NPC_PUKURIN")
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_diguda = SkySceneKit.spawn_npc("diglett", 248, 448, Direction.Left, "NPC_DIGUDA")
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 352, 472, Direction.UpRight, "NPC_HEIGANI")
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "happy", 1) end)
  -- SetAnimation(4) [anim idle native]
  -- SetAnimation(4) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Foggy Forest.ogg", true) end)
  GROUND:MoveToPosition(npc_npc_bippa, 296, 508, false, 2)
  GROUND:MoveToPosition(hero, 312, 532, false, 2)
  GROUND:MoveToPosition(partner, 280, 532, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Howdy, folks! Sorry to keep\nyou all waiting!", french="Chalut la compagnie! Désolés\nd'vous avoir fait attendre!", german="Hallihallo, Leute! Tut mir leid,\ndass ihr auf uns warten musstet!", italian="Ciao a tutti! Ci spiace avervi\nfatto aspettare!", spanish="¡Hola, amigos! ¡Sentimos haberos\nhecho esperar!"})
  -- message_Close
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  local npc_npc_kimawari = SkySceneKit.spawn_npc("sunflora", 224, 448, Direction.Right, "NPC_KIMAWARI")
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "exclaim", 1) end)
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownRight)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_diguda, Direction.DownRight)
  GAME:WaitFrames(10)
  local npc_npc_guregguru = SkySceneKit.spawn_npc("croagunk", 368, 456, Direction.DownLeft, "NPC_GUREGGURU")
  pcall(function() GROUND:CharSetEmote(npc_npc_guregguru, "exclaim", 1) end)
  GROUND:EntTurn(npc_npc_heigani, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: se_Play(8970) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "angry", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You all are late! Everyone else\narrived a long time ago!", french="Vous êtes en retard! Tous les\nautres sont déjà arrivés depuis longtemps!", german="Ihr verspätet euch! Alle anderen\nsind schon längst da!", italian="Siete in ritardo! Tutti gli altri\nsono già arrivati da un pezzo!", spanish="¡Llegáis tarde! ¡Los demás\nllegaron hace mucho!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urgh...", french=" Argh...", german=" Umpf...", italian=" Urgh...", spanish=" Ay..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urgh...", french=" Argh...", german=" Umpf...", italian=" Urgh...", spanish=" Pues vaya."})
  else
  SkySceneKit.say({english=" Urgh...", french=" Argh...", german=" Umpf...", italian=" Urgh...", spanish=" Ay..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Go set your equipment down.\nMake haste!", french="Allez déposer votre équipement.\nDépêchez-vous!", german="Legt eure Ausrüstung ab.\nBeeilt euch!", italian="Andate a depositare le vostre\ncose. Muovetevi!", spanish="Dejad ahí vuestras cosas.\n¡Rapidito!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Now that everyone's assembled,\nlet's get on with our strategy briefing.", french="Maintenant que nous sommes\ntous rassemblés, faisons une petite réunion\npour revoir notre stratégie.", german="Jetzt, wo alle versammelt sind,\nkommen wir zur strategischen Besprechung.", italian="Adesso che siamo tutti qui,\nprocediamo con la riunione sulla strategia.", spanish="Ahora que ya estamos todos,\nrepasemos nuestra estrategia."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Yes sirree!", french=" Ouaip!", german=" Jawollja!", italian=" Sissignore!", spanish=" ¡Sí, señor!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  do local p=npc_npc_kimawari.Position; GROUND:MoveToPosition(npc_npc_kimawari, p.X+(0), p.Y+(-80), false, 2) end
  do local p=npc_npc_guregguru.Position; GROUND:MoveToPosition(npc_npc_guregguru, p.X+(0), p.Y+(-80), false, 2) end
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_perappu, 296, 396, false, 2)
  GROUND:MoveToPosition(npc_npc_bippa, 296, 444, false, 1)
  do local p=npc_npc_diguda.Position; GROUND:MoveToPosition(npc_npc_diguda, p.X+(0), p.Y+(-80), false, 2) end
  do local p=npc_npc_heigani.Position; GROUND:MoveToPosition(npc_npc_heigani, p.X+(0), p.Y+(-80), false, 2) end
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(partner, 280, 500, false, 1)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  -- GAP: SetEffect EFFECT_TWO_ARROWS_AT_SIDE_LEFT — VFX sans émote PMDO équivalente
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, hero, 4) end)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hm? What's up, [hero]?", french=" Quoi? Qu'y a-t-il, [hero]?", german=" Hm? Was ist los, [hero]?", italian=" Eh? Cosa c'è, [hero]?", spanish=" ¿Qué pasa, [hero]?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hm? What's wrong,\n[hero]?", french=" Quoi? Qu'y a-t-il, [hero]?", german="Hm? Stimmt was nicht,\n[hero]?", italian="Eh? Cosa c'è che non va,\n[hero]?", spanish=" ¿Qué te pasa, [hero]?"})
  else
  SkySceneKit.say({english="Hm? What's wrong,\n[hero]?", french=" Quoi? Qu'y a-t-il, [hero]?", german="Hm? Stimmt was nicht,\n[hero]?", italian="Eh? Cosa c'è che non va,\n[hero]?", spanish=" ¿Qué te ocurre, [hero]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...)", french="(...)", german="(...)", italian="(...)", spanish="(...)"})
  else
  SkySceneKit.say({english="(...)", french="(...)", german="(...)", italian="(...)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What's this weird sensation?)", french="(Quelle est cette sensation étrange?)", german="(Was ist das für ein seltsames Gefühl?)", italian="(Cos'è questa strana sensazione?)", spanish="(¿Qué es esa sensación tan rara?)"})
  else
  SkySceneKit.say({english="(What's this weird sensation?)", french="(Quelle est cette sensation étrange?)", german="(Was ist das für ein seltsames Gefühl?)", italian="(Cos'è questa strana sensazione?)", spanish="(¿Qué es esa sensación tan rara?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I don't know why I'm feeling this way...)", french="(Je ne sais pas pourquoi je ressens ça...)", german="(Ich weiß nicht, woher es kommt.)", italian="(Non so perché mi sento così...)", spanish="(No sé por qué me siento así.)"})
  else
  SkySceneKit.say({english="(I don't know why I'm feeling this way...)", french="(Je ne sais pas pourquoi je ressens ça...)", german="(Ich weiß nicht, woher es kommt.)", italian="(Non so perché mi sento così...)", spanish="(No sé por qué me siento así.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I...)", french="(Je...)", german="(Ich...)", italian="(Io...)", spanish="(Yo...)"})
  else
  SkySceneKit.say({english="(I...)", french="(Je...)", german="(Ich...)", italian="(Io...)", spanish="(Yo...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Wait a second! I know this place!)", french="(C'est ça! Je connais cet endroit!)", german="(Moment mal! Ich kenne diesen Ort!)", italian="(Un secondo! Questo posto lo conosco!)", spanish="(¡Un momento! ¡Yo conozco este sitio!)"})
  else
  SkySceneKit.say({english="(Wait a second! I know this place!)", french="(C'est ça! Je connais cet endroit!)", german="(Moment mal! Ich kenne diesen Ort!)", italian="(Un secondo! Questo posto lo conosco!)", spanish="(¡Un momento! ¡Yo conozco este sitio!)"})
  end
  -- message_KeyWait
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Have I been here before?)", french="(Suis-je déjà venu ici?)", german="(War ich schon einmal hier?)", italian="(Sono già stato qui?)", spanish="(¿No he estado aquí antes?)"})
  else
  SkySceneKit.say({english="(Have I been here before?)", french="(Suis-je déjà venue ici?)", german="(War ich schon einmal hier?)", italian="(Sono già stata qui?)", spanish="(¿No he estado aquí antes?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Maybe.)", french="(Peut-être.)", german="(Vielleicht.)", italian="(Forse.)", spanish="(Tal vez.)"})
  else
  SkySceneKit.say({english="(Maybe.)", french="(Peut-être.)", german="(Vielleicht.)", italian="(Forse.)", spanish="(Tal vez.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Does it have something to do with me?\nBefore I lost my memory?)", french="(Est-ce que ça a un rapport avec moi?\nAvant que je ne perde la mémoire?)", german="(Hat der Ort etwas mit mir zu tun?\nWar ich schon mal hier, bevor ich mein\nGedächtnis verloren habe?)", italian="(Ha qualcosa a che fare con me?\nPrima che perdessi la memoria?)", spanish="(¿Tendrá algo que ver conmigo? ¿Antes de que\nperdiera la memoria?)"})
  else
  SkySceneKit.say({english="(Does it have something to do with me?\nBefore I lost my memory?)", french="(Est-ce que ça a un rapport avec moi?\nAvant que je ne perde la mémoire?)", german="(Hat der Ort etwas mit mir zu tun?\nWar ich schon mal hier, bevor ich mein\nGedächtnis verloren habe?)", italian="(Ha qualcosa a che fare con me?\nPrima che perdessi la memoria?)", spanish="(¿Tendrá algo que ver conmigo? ¿Antes de que\nperdiera la memoria?)"})
  end
  -- message_Close
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(24), p.Y+(0), false, 2) end
  GROUND:MoveToPosition(npc_npc_perappu, 320, 436, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "happy", 1) end)
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitSe
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GROUND:EntTurn(npc_npc_bippa, Direction.UpRight)
  GROUND:EntTurn(partner, Direction.UpRight)
  -- message_FacePositionOffset(-2, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Come on, come on! We haven't\ngot all day!", french="Allez, allez! On n'a pas toute\nla journée!", german="Kommt schon, kommt! Wir haben\nnicht den ganzen Tag Zeit!", italian="Forza, forza! Non abbiamo\ntutto il giorno!", spanish=" ¡Venga, no tenemos todo el día!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's move it, [hero].", french="Il faut qu'on y aille,\n[hero].", german=" Gehen wir los, [hero].", italian=" Sbrighiamoci, [hero].", spanish=" Vámonos, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go, [hero].", french="Il faut qu'on y aille,\n[hero].", german=" Gehen wir, [hero].", italian=" Sbrighiamoci, [hero].", spanish=" Vamos, [hero]."})
  else
  SkySceneKit.say({english=" We have to go, [hero].", french="Il faut qu'on y aille,\n[hero].", german="Wir müssen gehen,\n[hero].", italian=" Sbrighiamoci, [hero].", spanish="Tenemos que irnos,\n[hero]."})
  end
  -- message_Close
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(0), p.Y+(-80), false, 2) end
  GAME:WaitFrames(10)
  do local p=npc_npc_bippa.Position; GROUND:MoveToPosition(npc_npc_bippa, p.X+(0), p.Y+(-80), false, 2) end
  GAME:WaitFrames(15)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(-120), false, 2) end
  GAME:WaitFrames(45)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-120), false, 2) end
  GAME:WaitFrames(60)
  GAME:FadeOut(false,  30)
  GAME:WaitFrames(60)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:WaitFrames(1)
  pcall(function() GAME:MoveCamera(300, 412, 1, false) end) -- SetPositionMark performer/caméra
  GROUND:TeleportTo(hero, 364, 412, Direction.Down)
  GROUND:TeleportTo(partner, 364, 432, Direction.Down)
  GROUND:TeleportTo(npc_npc_bippa, 300, 412, Direction.Down)
  GROUND:TeleportTo(npc_npc_perappu, 300, 380, Direction.Down)
  GROUND:TeleportTo(npc_npc_diguda, 332, 432, Direction.Down)
  GROUND:TeleportTo(npc_npc_kimawari, 332, 412, Direction.Down)
  GROUND:TeleportTo(npc_npc_guregguru, 236, 412, Direction.Down)
  GROUND:TeleportTo(npc_npc_heigani, 268, 432, Direction.Down)
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_bippa, Direction.Up)
  GROUND:EntTurn(npc_npc_diguda, Direction.Up)
  GROUND:EntTurn(npc_npc_kimawari, Direction.Up)
  GROUND:EntTurn(npc_npc_heigani, Direction.Up)
  GROUND:EntTurn(npc_npc_guregguru, Direction.UpRight)
  -- SetPositionInitial [position SSA de départ, déjà posée par le placement de scène]
  -- SetAnimation(2) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild Remix.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Erm... Attention, please.", french="Hum... Votre attention, s'il vous\nplaît.", german=" Ähem, alles mal herhören, bitte.", italian="Ehi... Un attimo di attenzione,\nper favore.", spanish=" A ver... Atención, por favor."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="It appears everyone has arrived\nat our base camp safe and sound.", french="Tout le monde est arrivé au\ncamp de base sain et sauf.", german="Wie es aussieht, sind alle\nwohlbehalten am Basislager angekommen.", italian="Sembra che tutti abbiano\nraggiunto il Campo Base sani e salvi.", spanish="Parece que todos hemos llegado\nal campamento base sanos y salvos."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="We shall now proceed to the\nexploration of [CS:P]Fogbound Lake[CR]! ♪", french="Nous allons donc pouvoir\nexplorer le [CS:P]Lac des Brumes[CR]! ♪", german="Wir werden jetzt die Erkundung\ndes [CS:P]Nebelsees[CR] in Angriff nehmen! ♪", italian="Adesso dobbiamo dedicarci\nall'esplorazione del [CS:P]Lago Foschia[CR]! ♪", spanish="¡Ahora procederemos a explorar\nel [CS:P]Lago Velado[CR]! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="As you can see, we are in a\ndensely forested area.", french="Comme vous pouvez le\nconstater, nous sommes dans une région\ndensément boisée.", german="Wie ihr seht, befinden wir uns\nin einem dicht bewaldeten Gebiet.", italian="Come potete vedere, siamo\ncircondati da una fitta foresta.", spanish="Como podéis ver, estamos\njunto a un bosque densamente poblado."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Somewhere within this forest,\n[CS:P]Fogbound Lake[CR] is supposedly concealed...", french="Le [CS:P]Lac des Brumes[CR] est censé se\ntrouver quelque part dans cette forêt...", german="Irgendwo in diesem Wald soll\nder [CS:P]Nebelsee[CR] verborgen sein...", italian="Da qualche parte in questa\nforesta dovrebbe trovarsi il [CS:P]Lago Foschia[CR]...", spanish="Dicen que el [CS:P]Lago Velado[CR] está\nescondido en alguna parte de este bosque..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="But so far, that has been nothing\nmore than a rumor.", french="Mais jusqu'à présent, la rumeur\nn'a jamais pu être confirmée.", german="Aber bis jetzt ist das nichts\nweiter als ein Gerücht.", italian=" Nessuno l'ha mai trovato finora.", spanish="Pero, hasta ahora, no ha habido\nmás que rumores."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Exploration teams of all stripes\nhave mounted many a challenge, but so far\nthe lake has eluded discovery.", french="Des équipes d'exploration de\ntoutes sortes ont relevé le défi, mais le lac\nn'a toujours pas été découvert.", german="Zahllose Erkundungsteams haben\nschon ihr Glück versucht, aber bisher konnte\nder See nicht entdeckt werden.", italian="Squadre d'esplorazione di ogni\ntipo hanno condotto delle ricerche, ma finora\nnessuno è riuscito ad arrivarci.", spanish="Muchos equipos de exploración\nse han planteado este desafío, pero nadie ha\nsido capaz de encontrar el dichoso lago."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey, hey!", french=" Eh dis donc!", german=" Hey, hey, hey!", italian=" Ehi, ehi, ehi!", spanish=" ¡Oye, oye!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_heigani, 4) end)
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownLeft)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_heigani, 4) end)
  local npc_npc_dogoomu = SkySceneKit.spawn_npc("loudred", 304, 432, Direction.Up, "NPC_DOGOOMU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_heigani, 4) end)
  local npc_npc_chiriin = SkySceneKit.spawn_npc("chimecho", 272, 416, Direction.Up, "NPC_CHIRIIN")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_heigani, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_heigani, 4) end)
  local npc_npc_dagutorio = SkySceneKit.spawn_npc("dugtrio", 240, 432, Direction.UpRight, "NPC_DAGUTORIO")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_heigani, 4) end)
  local npc_npc_sukatanku = SkySceneKit.spawn_npc("skuntank", 240, 392, Direction.Right, "NPC_SUKATANKU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sukatanku, npc_npc_heigani, 4) end)
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 232, 368, Direction.DownRight, "NPC_ZUBATTO")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_zubatto, npc_npc_heigani, 4) end)
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 208, 384, Direction.Right, "NPC_DOGAASU")
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogaasu, npc_npc_heigani, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey! So is it really there or\nwhat?![K] This [CS:P]Fogbound Lake[CR]?!", french="Je dirais même plus: eh dis\ndonc! Il est vraiment ici ou quoi\nce [CS:P]Lac des Brumes[CR]?!", german="Hey, hey! Also gibt es ihn nun,\noder was?!?[K] Diesen [CS:P]Nebelsee[CR]?!?", italian="Ehi, ehi! Ma allora esiste\ndavvero...[K] questo [CS:P]Lago Foschia[CR]?!", spanish="¡Oye, oye! ¡¿Entonces está aquí\nde verdad?![K] ¡¿Está aquí ese [CS:P]Lago Velado[CR]?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(4) [anim idle native]
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Silly [CS:N]Corphish[CR].", french="Ben mince alors! Tu es trop\nbête, [CS:N]Ecrapince[CR].", german=" Sei nicht albern, [CS:N]Krebscorps[CR].", italian=" Sciocco [CS:N]Corphish[CR].", spanish=" No seas bobo, [CS:N]Corphish[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="You'll wreck the dream if you\nsay something like that.", french="En disant des choses pareilles,\ntu vas nous anéantir notre rêve!", german="Du machst die Illusion kaputt,\nwenn du so etwas sagst.", italian="Rovini il nostro sogno dicendo\ncose del genere.", spanish="Le vas a quitar a esto la\nemoción si continúas hablando."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" Yeah, don't spoil things now!", french=" Ouais, viens pas tout GACHER!", german=" Ja, verdirb uns nicht den Spaß!", italian=" Sì, non rovinare tutto adesso!", spanish=" ¡Eso, no lo estropees ahora!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_heigani, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english=" Hey, hey...", french=" Eh dis donc...", german=" Hey, hey...", italian=" Ehi, ehi...", spanish=" Perdón..."})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  pcall(function() SOUND:FadeOutBGM(120) end)
  -- message_FacePositionOffset(3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english=" Um, may I?", french="Hum hum! Si je peux\nme permettre...", german=" Ähm, darf ich was sagen?", italian=" Ehm, posso?", spanish=" Hum, ¿me permitís?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_chiriin, 4) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_chiriin, 4) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_chiriin, 4) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_chiriin, 4) end)
  GAME:WaitFrames(2)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sukatanku, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_zubatto, npc_npc_chiriin, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogaasu, npc_npc_chiriin, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Um, while we were traveling, I\nheard about a certain legend.", french="Pendant le voyage,\nj'ai entendu parler d'une légende.", german="Ähm, auf unserer Reise habe ich\neine Legende gehört.", italian="Uhm, mentre eravamo in viaggio,\nho sentito una leggenda.", spanish="Mientras viajábamos,\nhe escuchado una leyenda peculiar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" A legend, you say?", french=" Une légende, dis-tu?", german=" Eine Legende, sagst du?", italian=" Una leggenda?", spanish=" ¿Una leyenda, dices?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Yes. A legend about [CS:P]Fogbound\nLake[CR].", french="Oui. Une légende sur le [CS:P]Lac des\nBrumes[CR].", german="Ja. Eine Legende über den\n[CS:P]Nebelsee[CR].", italian="Sì. Una leggenda che riguarda il\n[CS:P]Lago Foschia[CR].", spanish="Así es. Una leyenda sobre el\n[CS:P]Lago Velado[CR]."})
  -- message_KeyWait
  -- GAP: BGM BGM_I_SAW_SOMETHING_AGAIN non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="According to the legend,\n[CS:P]Fogbound Lake[CR] is home to a Pokémon named\n[CS:N]Uxie[CR].", french="Selon la légende, le [CS:P]Lac\ndes Brumes[CR] est la demeure d'un Pokémon\ndu nom de [CS:N]Créhelf[CR].", german="Der Legende zufolge lebt am\n[CS:P]Nebelsee[CR] ein Pokémon namens [CS:N]Selfe[CR].", italian="Secondo la leggenda, presso il\n[CS:P]Lago Foschia[CR] vive un Pokémon chiamato\n[CS:N]Uxie[CR].", spanish="Según la leyenda, en el [CS:P]Lago[CR]\n[CS:P]Velado[CR] vive un Pokémon llamado [CS:N]Uxie[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="The Pokémon is said to be\nexceedingly rare.", french="On raconte que ce Pokémon est\nextrêmement rare.", german="Dieses Pokémon soll\nausgesprochen selten sein.", italian="Si dice che sia un Pokémon\nrarissimo.", spanish="Se dice que este Pokémon\nes extremadamente raro."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="[CS:N]Uxie[CR] is said to lock eyes with\nothers and wipe their memories clean.", french="A ce qu'il paraît, [CS:N]Créhelf[CR] peut\neffacer la mémoire des gens, simplement\nen les regardant droit dans les yeux.", german="[CS:N]Selfe[CR] kann angeblich das\nGedächtnis von anderen auslöschen, indem es\nihnen in die Augen sieht.", italian="Dicono che [CS:N]Uxie[CR] sia in grado di\ncancellare la memoria degli altri Pokémon\nsemplicemente incrociandone lo sguardo.", spanish="Al parecer, [CS:N]Uxie[CR] puede borrarte\nla memoria con solo mirarte."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(What?![K] Wipe their memories clean?!)", french="(Quoi?![K] Effacer la mémoire des gens?!)", german="(Was?!?[K] Es löscht ihr Gedächtnis aus?!?)", italian="(Cosa?![K] Cancellare la memoria?!)", spanish="(¡¿Cómo?![K] ¡¿Borrarte la memoria?!)"})
  else
  SkySceneKit.say({english="(What?![K] Wipe their memories clean?!)", french="(Quoi?![K] Effacer la mémoire des gens?!)", german="(Was?!?[K] Es löscht ihr Gedächtnis aus?!?)", italian="(Cosa?![K] Cancellare la memoria?!)", spanish="(¡¿Cómo?![K] ¡¿Borrarte la memoria?!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="That is why, even if travelers\nwere to happen upon [CS:P]Fogbound Lake[CR]...", french="C'est pour ça que même si des\nexplorateurs sont déjà arrivés jusqu'au [CS:P]Lac\ndes Brumes[CR]...", german="Selbst wenn Reisende den\n[CS:P]Nebelsee[CR] finden würden...", italian="È per questo che, anche se dei\nviaggiatori riuscissero a trovare il [CS:P]Lago[CR]\n[CS:P]Foschia[CR]...", spanish="Por eso, si algún viajero\nconsiguiera encontrar el [CS:P]Lago Velado[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="[CS:N]Uxie[CR] would wipe their\nmemories clean...", french="... [CS:N]Créhelf[CR] a dû leur effacer\nla mémoire...", german="[CS:N]Selfe[CR] würde ihr Gedächtnis\nlöschen.", italian="[CS:N]Uxie[CR] ne cancellerebbe la\nmemoria...", spanish=" [CS:N]Uxie[CR] le borraría la memoria."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="Thereby muzzling the travelers\nfrom revealing the existence of the lake.", french="... les empêchant ainsi\nde révéler l'existence du lac.", german="Und würde somit verhindern,\ndass die Reisenden etwas von der Existenz des\nSees verraten könnten.", italian="... impedendo loro di rivelare\nl'esistenza del lago.", spanish="De esta forma evita que los\nviajeros revelen la existencia del lago."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="And that is how [CS:N]Uxie[CR] protects\n[CS:P]Fogbound Lake[CR].", french="Et c'est comme ça que [CS:N]Créhelf[CR]\nprotège le [CS:P]Lac des Brumes[CR].", german="Auf diese Weise schützt [CS:N]Selfe[CR]\nden [CS:P]Nebelsee[CR].", italian="Ed è così che [CS:N]Uxie[CR] protegge il\n[CS:P]Lago Foschia[CR].", spanish="Y así es como [CS:N]Uxie[CR] protege\nel [CS:P]Lago Velado[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="I was told such a legend\nremains.", french="On m'a dit que cette légende\nn'a jamais été démentie.", german="Ich habe gehört, dass es so eine\nLegende bis heute gibt.", italian="Questo è tutto ciò che\nsi sa, pare.", spanish="Al parecer, eso es lo que cuenta\nla leyenda."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_bippa, "sweating", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="Golly, that's a pretty hair-raising\ntale...", french="Pour sûr, elle m'fait peur, ton\nhistoire...", german="Menschenskind, das ist aber eine\nhaarsträubende Geschichte.", italian=" Ohibò, che racconto spaventoso...", spanish="Huy, es una historia ciertamente\nespeluznante..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "sweatdrop", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english="What'll I do if my MEMORY is\nwiped clean?", french="Qu'est-ce que je vais faire si\nma MEMOIRE est effacée?", german="Was mache ich denn, wenn mein\nGEDÄCHTNIS ausgelöscht wird?", italian="Cosa farò se mi cancellano\nla MEMORIA?", spanish="¿Qué haría yo si me borraran\nla memoria?"})
  GAME:WaitFrames(2) -- join WaitEffect
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_dogoomu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_pukurin, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_perappu, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_kimawari, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_kimawari, 4) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="I don't think you have much to\nworry about.", french="Si tu veux mon avis, toi, tu\nn'as ab-so-lu-ment aucun souci à te faire!", german="Ich glaube nicht, dass du dir\ngroße Sorgen machen musst.", italian="Tu non hai molto di cui\npreoccuparti.", spanish="No creo que tú tengas mucho de\nqué preocuparte."})
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english="After all, you're so forgetful\nanyway, you make me go eek!", french="C'est vrai, quoi! Tu oublies déjà\ntout, tu me rends dingue! On ne verra même\npas la différence!", german="Du bist doch sowieso so\nvergesslich, dass es zum Schreien ist! Ieek!", italian="Dopotutto, sei così smemorato\nche mi fai sempre perdere le staffe!", spanish="Eres tan olvidadizo que a mí es\nque me... ¡Ay!"})
  -- message_Close
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Ahem.", french=" Hum hum.", german=" Ähem.", italian=" Ahem.", spanish=" Ejem."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_kimawari, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_diguda, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_bippa, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogoomu, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_heigani, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_guregguru, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dagutorio, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_sukatanku, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_zubatto, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_chiriin, npc_npc_perappu, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_dogaasu, npc_npc_perappu, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You should realize that places of\nthis sort can be expected to have a folktale\nor a legend attached to them.", french="C'est normal que de tels\nendroits fassent l'objet d'un conte ou\nd'une légende.", german="Ihr solltet wissen, dass über\nsolche Orte gerne Märchen oder Legenden\nverbreitet werden.", italian="È facile che posti del genere\nispirino la diffusione di storie o leggende.", spanish="Tenéis que ser conscientes de\nque siempre hay leyendas así sobre este tipo\nde lugares."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Our guild has overcome difficult\nchallenges and obstacles when conducting\nsuccessful explorations. ♪", french="Notre Guilde a surmonté bien\ndes épreuves et des défis difficiles lors\nd'explorations fructueuses. ♪", german="Unsere Gilde hat auf ihren\nerfolgreichen Expeditionen große Hindernisse\nund Schwierigkeiten überwunden. ♪", italian="La nostra Gilda ha superato\nsfide ed ostacoli portando a termine\ncon successo le sue esplorazioni. ♪", spanish="Este [CS:N]Pokégremio[CR] ha superado\ndesafíos y obstáculos supuestamente\ninsalvables en sus exploraciones. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Absolutely, eek!", french=" Absolument! Hiii!", german=" Allerdings, ieek!", italian=" Assolutamente, eek!", spanish=" ¡Ay, claro que sí!"})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(4) [anim idle native]
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="That's how our guild has earned\nthe reputation for being first class.", french="C'est ainsi que notre Guilde a\nacquis sa réputation de guilde de premier\nordre.", german="Daher kommt unser\nerstklassiger Ruf als Gilde.", italian="È così che la nostra Gilda\nsi è guadagnata la reputazione di essere\nuna delle migliori.", spanish="Así es como este [CS:N]Pokégremio[CR]\nse ha ganado su excelente reputación."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  do local p=npc_npc_pukurin.Position; GROUND:MoveToPosition(npc_npc_pukurin, p.X+(0), p.Y+(8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Ha ha ha! Don't worry,\neverything will be all right! ♪", french="Ha ha ha! Ne vous inquiétez pas,\ntout va bien se passer! ♪", german="Hahaha! Keine Angst, alles wird\ngut! ♪", italian="Ah ah ah! Non preoccupatevi,\nandrà tutto bene! ♪", spanish="¡Ja, ja, ja! No os preocupéis,\n¡no va a pasar nada! ♪"})
  GROUND:EntTurn(npc_npc_perappu, Direction.UpRight)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english="Let's believe in success for this\nadventure too, and...", french="Croyons au succès de cette\naventure, et...", german="Lasst uns auch auf diesem\nAbenteuer positiv denken, und...", italian="Dobbiamo confidare nel\nsuccesso di questa avventura e...", spanish="Debemos creer también en el\néxito de esta empresa y..."})
  -- message_KeyWait
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_pukurin) end)
  SkySceneKit.say({english=" Let's try! ♪ Let's try! ♪", french="On va essayer! ♪ On va\nessayer! ♪", german="Versuchen wir es! ♪\nVersuchen wir es! ♪", italian=" Proviamo! ♪ Proviamo! ♪", spanish="¡Hay que intentarlo! ♪\n¡Hay que intentarlo! ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_pukurin, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  GROUND:EntTurn(npc_npc_perappu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Let's move on with our plan.", french=" Poursuivons les explications.", german=" Fahren wir mit dem Plan fort.", italian=" Continuiamo con il nostro piano.", spanish=" Sigamos con el plan."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="The Guildmaster and I shall\nremain here to gather intelligence from our\nteams in the field.", french="Le Maître et moi resterons ici\npour rassembler les informations que vous\nrapporterez de vos explorations sur le terrain.", german="Der Gildenmeister und ich\nwerden hierbleiben, um Informationen von\nden Teams im Einsatz zu sammeln.", italian="Io e il Capitano rimarremo\nqui per raccogliere informazioni dalle\nnostre squadre sul campo.", spanish="El Gran Bluff y yo aguardaremos\naquí para coordinar la información que\nrecaben los distintos equipos."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="You are to go off in teams to\nexplore this forest.", french="Vous allez former diverses\néquipes pour explorer cette forêt.", german="Ihr werdet in Teams aufbrechen,\num diesen Wald zu erkunden.", italian="Voi andrete a esplorare questa\nforesta divisi in squadre.", spanish="Vosotros os dividiréis en equipos\npara explorar todo el bosque."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Be aware that this forest is\nenshrouded in a deep fog. Once you enter it,\nvisibility is severely restricted.", french="Sachez qu'elle est enveloppée\ndans un épais brouillard. Quand vous y\nentrez, la visibilité est très réduite.", german="Denkt daran, dass dieser Wald\nvon dichtem Nebel umhüllt ist. Betretet ihr ihn\nerst einmal, ist eure Sicht sehr eingeschränkt.", italian="Sappiate che la foresta è\navvolta da una fitta nebbia. Una volta entrati,\nla visibilità sarà estremamente ridotta.", spanish="Tened en cuenta que este bosque\nestá cubierto por una densa niebla. Una\nvez que entréis, la visibilidad será limitada."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="We think that [CS:P]Fogbound Lake[CR] has\ndefied discovery because of this fog.", french="Nous pensons que c'est à cause\nde ce brouillard que le [CS:P]Lac des Brumes[CR] n'a pas\nété découvert.", german="Wir glauben, dass der [CS:P]Nebelsee[CR]\nwegen dieses Nebels bisher unentdeckt blieb.", italian="Pensiamo che il [CS:P]Lago Foschia[CR] non\nsia ancora stato scoperto proprio a causa di\nquesta nebbia.", spanish="Creo que eso es lo que ha\nimpedido que nadie descubra el [CS:P]Lago Velado[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Perhaps there is a way of\nlifting this fog.", french="Il y a peut-être un moyen de\nfaire disparaître ce brouillard.", german="Vielleicht gibt es einen Weg,\ndiesen Nebel zu vertreiben.", italian="Forse esiste un modo per far\ndiradare la nebbia.", spanish="Tal vez haya alguna forma\nde eliminar esta niebla."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="Therefore, your search is\ntwofold. One, search for [CS:P]Fogbound Lake[CR].", french="Vous avez donc deux objectifs.\nPremièrement, chercher le [CS:P]Lac des\nBrumes[CR].", german="Darum sollt ihr nach zwei\nDingen suchen. Erstens, nach dem [CS:P]Nebelsee[CR].", italian="Per questo motivo, la vostra\nesplorazione ha due obiettivi. Uno, cercare il\n[CS:P]Lago Foschia[CR].", spanish="Por tanto, vuestra búsqueda\nes doble: por un lado, buscad el [CS:P]Lago Velado[CR]..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="And two, find a way to lift\nthe fog.", french="Deuxièmement, faire en sorte\nque le brouillard se lève.", german="Und zweitens, nach einer\nMöglichkeit, den Nebel zu vertreiben.", italian="Due, trovare un modo per far\ndiradare la nebbia.", spanish="Y por otro, encontrad la forma\nde disipar la niebla."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="If you accomplish either thing,\nreturn to the base camp and tell me or the\nGuildmaster.[K] That is all.", french="Si vous trouvez quoi que ce\nsoit, revenez au camp de base et prévenez\nle Maître ou moi.[K] C'est tout.", german="Wenn euch eins davon gelingt,\nkehrt zum Basislager zurück und erzählt es\nmir oder dem Gildenmeister.[K] Das ist alles.", italian="Se riuscite a portare a termine\nuno dei due obiettivi, tornate al Campo Base\ne avvertite me o il Capitano.[K] È tutto.", spanish="Si conseguís alguna de esas dos\ncosas, volved al campamento base y hablad\nconmigo o con el Gran Bluff.[K] Eso es todo."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="All right, everyone. ♪ Let's give\nit our best, as always. ♪", french="Allez, vous tous. ♪ Faites de\nvotre mieux, comme toujours. ♪", german="Nun gut, Pokémon. ♪ Geben wir\nunser Bestes, wie immer. ♪", italian="Forza, gente. ♪ Facciamo del\nnostro meglio, come sempre. ♪", spanish="Muy bien. ♪ Ahora, vamos todos\na esforzarnos al máximo, como siempre. ♪"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "happy", 1) end)
  GAME:WaitFrames(1)
  GROUND:EntTurn(npc_npc_guregguru, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_chiriin, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(24) [anim idle native]
  -- SetAnimation(23) [anim idle native]
  GROUND:EntTurn(npc_npc_kimawari, Direction.Up)
  -- SetAnimation(23) [anim idle native]
  -- SetAnimation(25) [anim idle native]
  GROUND:EntTurn(hero, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  GROUND:EntTurn(partner, Direction.Up)
  -- SetAnimation(66) [anim idle native]
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="[CS:N]Everyone[CR]: HOORAY!", french="[CS:N]Tous[CR]: HOURRA!", german="[CS:N]Alle[CR]: HURRA!", italian="[CS:N]Tutti[CR]: URRÀ!", spanish="[CS:N]Todos[CR]: ¡HURRA!"})
  -- message_Close
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dogoomu, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(partner, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(45)
  GROUND:EntTurn(hero, Direction.Left)
  GROUND:EntTurn(partner, Direction.Left)
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_diguda, Direction.Left)
  GROUND:EntTurn(npc_npc_bippa, Direction.Down)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Up)
  GROUND:EntTurn(npc_npc_heigani, Direction.UpRight)
  GROUND:EntTurn(npc_npc_guregguru, Direction.DownRight)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Right)
  GROUND:EntTurn(npc_npc_sukatanku, Direction.DownRight)
  GROUND:EntTurn(npc_npc_zubatto, Direction.DownRight)
  GROUND:EntTurn(npc_npc_chiriin, Direction.DownRight)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, "happy", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_kimawari) end)
  SkySceneKit.say({english=" Let's all try our best!", french=" Faisons de notre mieux!", german="Versuchen wir alle, unser Bestes\nzu geben!", italian=" Mettiamocela tutta!", spanish="¡Vamos a esforzarnos\nal máximo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kimawari, nil, 0) end) -- EFFECT_NONE
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english="It'd be nice if we made a\ndiscovery or two.", french="Ce s'rait bien si on faisait une\np'tite découverte, pour sûr!", german="Es wäre schön, wenn wir\nein, zwei Entdeckungen machen würden.", italian="Sarebbe bello fare una o due\nscoperte.", spanish="Sería genial descubrir algo\npor ahí."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, "happy", 1) end)
  -- message_FacePositionOffset(3, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_chiriin) end)
  SkySceneKit.say({english="We'll find the lake! I'm sure\nof it!", french="On va trouver le lac! J'en suis\nsûre!", german="Wir werden den See finden!\nIch bin mir sicher!", italian="Troveremo il lago! Ne sono\nsicura!", spanish="¡Vamos a encontrar ese lago!\n¡Estoy segura!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_chiriin, nil, 0) end) -- EFFECT_NONE
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dogoomu) end)
  SkySceneKit.say({english=" I'll be the FIRST to find it!", french="Je serai le PREMIER à le\ntrouver!", german="Ich werde der ERSTE sein, der\nihn findet!", italian=" Sarò il PRIMO a trovarlo!", spanish="¡Yo seré el primero en\nencontrarlo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, "happy", 1) end)
  GROUND:EntTurn(npc_npc_kimawari, Direction.Down)
  GROUND:EntTurn(npc_npc_bippa, Direction.DownRight)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Right)
  GROUND:EntTurn(npc_npc_heigani, Direction.Right)
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="Dad, do you think maybe\n[CS:P]Fogbound Lake[CR] could be under the ground?", french="Père, tu crois que le [CS:P]Lac des\nBrumes[CR] est souterrain?", german="Papa, glaubst du, der\n[CS:P]Nebelsee[CR] ist vielleicht unterirdisch?", italian="Papà, pensi che il [CS:P]Lago Foschia[CR]\npotrebbe trovarsi sottoterra?", spanish="Papá, a lo mejor nadie encuentra\nel [CS:P]Lago Velado[CR] porque es un lago subterráneo..."})
  pcall(function() UI:SetSpeaker(npc_npc_diguda) end)
  SkySceneKit.say({english="I was thinking we should try\nlooking underground.", french="Je me disais qu'on pourrait\ncreuser et chercher sous terre.", german="Ich habe mir überlegt, dass wir\nunter der Erde suchen sollten.", italian="Stavo pensando che dovremmo\nprovare a cercare sottoterra.", spanish=" ¿Y si lo buscamos bajo tierra?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_diguda, nil, 0) end) -- EFFECT_NONE
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, "happy", 1) end)
  GROUND:EntTurn(npc_npc_kimawari, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_bippa, Direction.DownLeft)
  GROUND:EntTurn(npc_npc_dogoomu, Direction.Left)
  GROUND:EntTurn(npc_npc_heigani, Direction.Left)
  -- message_FacePositionOffset(0, -1) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english="Ah, my son, my pride and joy.\nYou make me proud. Let's look underground.", french="Ah, notre fils, notre fierté et\nnotre bataille. Tu es tout ce que peut souhaiter\nun père. Allons chercher sous terre.", german="Ach, mein Sohn, mein ganzer\nStolz. Du hast ja so recht. Lass uns unter\nder Erde suchen.", italian="Hai ragione! Tu sì che sai dare\nsoddisfazione a un padre. Cerchiamo\nsottoterra.", spanish="Ah, hijo mío, la luz de mis ojos.\nEstoy orgulloso de ti. Miraremos bajo tierra."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_dagutorio, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_dagutorio, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_diguda, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_dagutorio) end)
  SkySceneKit.say({english=" OK, everyone, we're off.", french=" Bien! Nous partons.", german=" Okay, Pokémon, wir gehen.", italian=" Ok, gente, noi andiamo.", spanish=" Nosotros ya nos vamos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_dagutorio, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_diguda, Direction.Left)
  GAME:WaitFrames(30)
  -- GAP: se_Play(6422) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(25) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  GROUND:EntTurn(npc_npc_diguda, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- GAP: se_Play(6422) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(24) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_heigani, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_heigani) end)
  SkySceneKit.say({english="Hey, hey, hey! We can't afford\nto dawdle, either!", french="Eh dis donc! On ne peut pas non\nplus se permettre de perdre du temps!", german="Hey, hey, hey! Wir können uns\nauch nicht leisten, zu trödeln!", italian="Ehi, ehi, ehi! Neanche noi\nabbiamo tempo da perdere!", spanish="Oye, oye. No hay tiempo que\nperder."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() UI:SetSpeaker(npc_npc_bippa) end)
  SkySceneKit.say({english=" Yup yup! We need to hurry!", french=" Ouaip! Grouillons-nous!", german="Jawollja! Wir müssen uns\nbeeilen!", italian=" Già, già! Dobbiamo sbrigarci!", spanish=" Sí, señor. Hay que darse prisa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_bippa, 300, 260, false, 2)
  do local p=npc_npc_perappu.Position; GROUND:MoveToPosition(npc_npc_perappu, p.X+(64), p.Y+(0), false, 2) end
  GROUND:EntTurn(npc_npc_pukurin, Direction.Up)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.UpLeft)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(npc_npc_chiriin, 300, 260, false, 2)
  GAME:WaitFrames(10)
  GROUND:MoveToPosition(npc_npc_dogoomu, 300, 260, false, 2)
  GAME:WaitFrames(25)
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  GROUND:MoveToPosition(npc_npc_heigani, 300, 260, false, 2)
  GAME:WaitFrames(35)
  GROUND:MoveToPosition(npc_npc_kimawari, 300, 260, false, 2)
  GAME:WaitFrames(25)
  GROUND:MoveToPosition(npc_npc_guregguru, 300, 260, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GROUND:MoveToPosition(npc_npc_sukatanku, 300, 388, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_zubatto, 272, 364, false, 2)
  GAME:WaitFrames(5)
  GROUND:MoveToPosition(npc_npc_dogaasu, 256, 380, false, 2)
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownLeft)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_perappu, Direction.Left)
  GROUND:EntTurn(npc_npc_sukatanku, Direction.UpLeft)
  GROUND:EntTurn(npc_npc_zubatto, Direction.DownRight)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Well then, we should go too.\nHmm, boys? Chaw-haw-haw!", french="Ben nous aussi, on devrait\ny aller. Pas vrai, les gars? Gnark gnark gnark!", german="Na gut, wir sollten auch gehen.\nWas, Jungs? Cha-ha-ha!", italian="Anche noi dovremmo avviarci.\nChe ne dite, ragazzi? Ahr-ahr-ahr!", spanish="Vaya, supongo que nosotros\ntambién tendremos que partir, ¿verdad,\nchicos? ¡Jua, jua, jua!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Heh-heh-heh!", french=" Hin hin hin!", german=" Hehehe!", italian=" Eh-eh-eh!", spanish=" ¡Jue, jue, jue!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" Whoa-ho-ho!", french=" Mouarf mouarf mouarf!", german=" Whoahoho!", italian=" Uooh-ho-ho!", spanish=" ¡Jo, jo, jo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(npc_npc_sukatanku, 300, 260, false, 2)
  GROUND:EntTurn(npc_npc_zubatto, Direction.UpRight)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.UpRight)
  GROUND:EntTurn(npc_npc_pukurin, Direction.Up)
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  GAME:WaitFrames(60)
  GROUND:MoveToPosition(npc_npc_zubatto, 300, 260, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(npc_npc_dogaasu, 300, 260, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  pcall(function() GAME:MoveCamera(364, 412, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  GROUND:EntTurn(npc_npc_pukurin, Direction.DownRight)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_perappu, Direction.UpLeft)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We've got to go, [hero].", french=" Il faut y aller, [hero].", german=" Wir müssen los, [hero].", italian=" Dobbiamo andare, [hero].", spanish="Tenemos que irnos,\n[hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Let's go, [hero].", french=" Il faut y aller, [hero].", german=" Gehen wir, [hero].", italian=" Dobbiamo andare, [hero].", spanish="Hay que salir ya,\n[hero]."})
  else
  SkySceneKit.say({english=" We should go, [hero].", french=" Il faut y aller, [hero].", german=" Wir sollten gehen, [hero].", italian=" Dobbiamo andare, [hero].", spanish="Debemos partir ya,\n[hero]."})
  end
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" We need to hurry.", french=" Nous devons nous dépêcher.", german=" Wir müssen uns beeilen.", italian=" Dobbiamo affrettarci.", spanish=" Debemos darnos prisa."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" We need to hurry.", french=" Nous devons nous dépêcher.", german=" Wir müssen uns beeilen.", italian=" Dobbiamo affrettarci.", spanish=" Debemos apresurarnos."})
  else
  SkySceneKit.say({english=" We need to hurry.", french=" Nous devons nous dépêcher.", german=" Wir müssen uns beeilen.", italian=" Dobbiamo affrettarci.", spanish=" Hay que darse prisa."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...)", french="(...)", german="(...)", italian="(...)", spanish="(...)"})
  else
  SkySceneKit.say({english="(...)", french="(...)", german="(...)", italian="(...)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I know this place...)", french="(Je connais cet endroit...)", german="(Ich kenne diesen Ort...)", italian="(Conosco questo posto...)", spanish="(Me suena este sitio...)"})
  else
  SkySceneKit.say({english="(I know this place...)", french="(Je connais cet endroit...)", german="(Ich kenne diesen Ort...)", italian="(Conosco questo posto...)", spanish="(Me suena este sitio...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(According to the legend, the Pokémon [CS:N]Uxie[CR]\ncan wipe clean the memories of others.)", french="(Selon la légende, le Pokémon [CS:N]Créhelf[CR]\npeut effacer la mémoire.)", german="(Der Legende zufolge kann das Pokémon [CS:N]Selfe[CR]\ndas Gedächtnis von anderen löschen.)", italian="(Secondo la leggenda, [CS:N]Uxie[CR] può cancellare\nla memoria degli altri Pokémon.)", spanish="(Según la leyenda, [CS:N]Uxie[CR] puede borrar la\nmemoria a otros Pokémon.)"})
  else
  SkySceneKit.say({english="(According to the legend, the Pokémon [CS:N]Uxie[CR]\ncan wipe clean the memories of others.)", french="(Selon la légende, le Pokémon [CS:N]Créhelf[CR]\npeut effacer la mémoire.)", german="(Der Legende zufolge kann das Pokémon [CS:N]Selfe[CR]\ndas Gedächtnis von anderen löschen.)", italian="(Secondo la leggenda, [CS:N]Uxie[CR] può cancellare\nla memoria degli altri Pokémon.)", spanish="(Según la leyenda, [CS:N]Uxie[CR] puede borrar la\nmemoria a otros Pokémon.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Are these two things really just a\ncoincidence?)", french="(Est-ce que ce n'est qu'une coïncidence?)", german="(Ist das beides wirklich nur Zufall?)", italian="(Che sia solo una coincidenza?)", spanish="(¿Será una mera coincidencia?)"})
  else
  SkySceneKit.say({english="(Are these two things really just a\ncoincidence?)", french="(Est-ce que ce n'est qu'une coïncidence?)", german="(Ist das beides wirklich nur Zufall?)", italian="(Che sia solo una coincidenza?)", spanish="(¿Será una mera coincidencia?)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Hmm.)", french="(Hum.)", german="(Hmm.)", italian="(Mmm.)", spanish="(Hum...)"})
  else
  SkySceneKit.say({english="(Hmm.)", french="(Hum.)", german="(Hmm.)", italian="(Mmm.)", spanish="(Hum...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Maybe I came here before I lost my memory.)", french="(Peut-être suis-je déjà venu ici avant de\nperdre la mémoire.)", german="(Vielleicht war ich hier, bevor ich mein\nGedächtnis verloren habe.)", italian="(Forse sono stato qui prima di perdere la\nmemoria.)", spanish="(Quizás estuve en este sitio antes de perder\nla memoria.)"})
  else
  SkySceneKit.say({english="(Maybe I came here before I lost my memory.)", french="(Peut-être suis-je déjà venue ici avant de\nperdre la mémoire.)", german="(Vielleicht war ich hier, bevor ich mein\nGedächtnis verloren habe.)", italian="(Forse sono stata qui prima di perdere la\nmemoria.)", spanish="(Quizás estuve en este sitio antes de perder\nla memoria.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Then maybe I met [CS:N]Uxie[CR]...[K]and he wiped my\nmemory clean...)", french="(J'ai peut-être rencontré [CS:N]Créhelf[CR]...[K] et\nil aurait alors effacé ma mémoire...)", german="(Vielleicht habe ich dann [CS:N]Selfe[CR] getroffen...[K]\nUnd es hat mein Gedächtnis ausgelöscht...)", italian="(Potrei aver incontrato [CS:N]Uxie[CR]...[K] che mi ha\ncancellato la memoria...)", spanish="(Quién sabe si aquí me encontré con [CS:N]Uxie[CR]...[K]\ny me borró la memoria...)"})
  else
  SkySceneKit.say({english="(Then maybe I met [CS:N]Uxie[CR]...[K]and he wiped my\nmemory clean...)", french="(J'ai peut-être rencontré [CS:N]Créhelf[CR]...[K] et\nil aurait alors effacé ma mémoire...)", german="(Vielleicht habe ich dann [CS:N]Selfe[CR] getroffen...[K]\nUnd es hat mein Gedächtnis ausgelöscht...)", italian="(Potrei aver incontrato [CS:N]Uxie[CR]...[K] che mi ha\ncancellato la memoria...)", spanish="(Quién sabe si aquí me encontré con [CS:N]Uxie[CR]...[K]\ny me borró la memoria...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Could that have happened?)", french="(Est-ce que c'est ce qui est arrivé?)", german="(Könnte das passiert sein?)", italian="(Che sia andata così?)", spanish="(¿Qué puede haber ocurrido?)"})
  else
  SkySceneKit.say({english="(Could that have happened?)", french="(Est-ce que c'est ce qui est arrivé?)", german="(Könnte das passiert sein?)", italian="(Che sia andata così?)", spanish="(¿Qué puede haber ocurrido?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey, [hero]!", french=" Hé, [hero]!", german=" Hey, [hero]!", italian=" Ehi, [hero]!", spanish=" ¡Oye, [hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey, [hero]!", french=" Hé, [hero]!", german=" Hey, [hero]!", italian=" Ehi, [hero]!", spanish=" ¡Oye, [hero]!"})
  else
  SkySceneKit.say({english=" Hey, [hero]!", french=" Hé, [hero]!", german=" Hey, [hero]!", italian=" Ehi, [hero]!", spanish=" ¡Oye, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Why do you keep drifting off\nlike that? It's not like you.", french="Pourquoi tu rêvasses comme\nça? Ça ne te ressemble pas.", german="Wieso bist du denn dauernd so\nabgelenkt? So bist du sonst nie.", italian="Perché continui a distrarti così?\nNon è da te.", spanish="¿Por qué estás tan ausente?\nNo es propio de ti."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Why do you keep drifting off\nlike that? It's not like you.", french="Pourquoi tu rêvasses comme\nça? Ça ne te ressemble pas.", german="Wieso bist du denn dauernd so\nabgelenkt? So bist du sonst nie.", italian="Perché continui a distrarti così?\nNon è da te.", spanish="Te veo muy ausente. No es\npropio de ti."})
  else
  SkySceneKit.say({english="Why do you keep drifting off\nlike that? It's not like you.", french="Pourquoi tu rêvasses comme\nça? Ça ne te ressemble pas.", german="Wieso bist du denn dauernd so\nabgelenkt? So bist du sonst nie.", italian="Perché continui a distrarti così?\nNon è da te.", spanish="Llevas un rato ausente. No es\npropio de ti."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Let's get our supplies together\nand go into the forest, quick!", french="Préparons-nous et partons pour\nla forêt, comme les autres!", german="Holen wir die Ausrüstung und\ngehen in den Wald, schnell!", italian="Recuperiamo le nostre provviste\ned entriamo nella foresta! Veloci!", spanish="¡Vamos a prepararnos y\nexploremos el bosque cuanto antes!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Hurry, let's get ready and go into\nthe forest!", french="Préparons-nous et partons pour\nla forêt, comme les autres!", german="Beeilung, holen wir unsere\nSachen und gehen in den Wald!", italian="Presto! Recuperiamo le nostre\nprovviste ed entriamo nella foresta!", spanish="¡Preparémonos y vayamos\nal bosque cuanto antes!"})
  else
  SkySceneKit.say({english="Let's get ready quickly and go\ninto the forest like the others!", french="Préparons-nous et partons pour\nla forêt, comme les autres!", german="Holen wir schnell unsere Sachen\nund gehen in den Wald!", italian="Recuperiamo le nostre provviste\ned entriamo nella foresta! Veloci!", spanish="¡Vamos a prepararnos y\nvayamos al bosque como los demás!"})
  end
  -- message_Close
  pcall(function() SOUND:PlayBGM("Foggy Forest.ogg", true) end)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[12] = 1 -- dungeon_mode(12) = DMODE_OPEN (ROM)
  SkySceneKit.cleanup_npcs()
end
