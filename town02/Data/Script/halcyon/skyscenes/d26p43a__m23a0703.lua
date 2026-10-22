-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D26P43A/m23a0703.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D26P43A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GROUND:MoveToPosition(hero, 292, 364, false, 2)
  GROUND:MoveToPosition(partner, 260, 364, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! [CS:N]Chatot[CR]!", french=" Eh, [CS:N]Pijako[CR]!", german=" Hey! [CS:N]Plaudagei[CR]!", italian=" Ehi! [CS:N]Chatot[CR]!", spanish=" ¡Oye! ¡[CS:N]Chatot[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey! [CS:N]Chatot[CR]!", french=" Eh, [CS:N]Pijako[CR]!", german=" Hey! [CS:N]Plaudagei[CR]!", italian=" Ehi! [CS:N]Chatot[CR]!", spanish=" ¡Oye! ¡[CS:N]Chatot[CR]!"})
  else
  SkySceneKit.say({english=" Hey! [CS:N]Chatot[CR]!", french=" Eh, [CS:N]Pijako[CR]!", german=" Hey! [CS:N]Plaudagei[CR]!", italian=" Ehi! [CS:N]Chatot[CR]!", spanish=" ¡Oye! ¡[CS:N]Chatot[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  local npc_npc_perappu = SkySceneKit.spawn_npc("chatot", 280, 328, Direction.Up, "NPC_PERAPPU")
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_perappu, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Hmmm. You two!", french=" Ah, vous voilà!", german=" Hmmm. Ihr beide!", italian=" Mmm. Voi due!", spanish=" Ah. ¡Aquí estáis!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" Be alert![K] They're very close by!", french="Restez sur vos gardes![K] Ils sont\ntout proches!", german="Seid wachsam![K] Sie sind ganz nah\nbei uns!", italian="Fate attenzione![K] Sono molto\nvicini!", spanish="¡Id con cuidado![K]\n¡Están muy cerca de nosotros!"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="I saw their retreating figures\nwhen I gave chase...", french="J'ai vu leur ombre quand\nje me suis lancé à leurs trousses...", german="Ich konnte ihre flüchtenden\nUmrisse erkennen, als ich sie verfolgte.", italian="Mentre li inseguivo ho visto le\nloro sagome che si ritraevano...", spanish="Vi algo que se movía y salí\nen su persecución..."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="But I'd lost sight of them by\nthe time I reached this spot.", french="Mais je les ai perdus de vue\nquand je suis arrivé ici.", german="Aber als ich an diese Stelle kam,\nhatte ich sie schon aus den Augen verloren.", italian=" Ma poi li ho persi di vista.", spanish="Pero, al llegar a este punto, ya\nno había nadie."})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="They must be lurking here\nsomewhere.", french="Ils nous ont sûrement tendu\nune embuscade pas loin.", german="Sie müssen hier irgendwo\nlauern.", italian="Devono essersi nascosti da\nqualche parte.", spanish="Sé que tienen que estar por\naquí, en alguna parte."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_perappu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(10)
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(partner, 236, 332, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(hero, 316, 332, false, 2)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(partner, 260, 300, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:MoveToPosition(hero, 292, 300, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(8963) — id SE NDS sans portage PMDO identifié
  -- ExecuteCommon(CORO_LOOK_AROUND_RIGHT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But...[K]there's just nowhere to\nhide here.", french="Mais...[K] il n'y a nulle part\noù se cacher ici.", german="Aber[K] hier kann man sich\nnirgendwo verstecken.", italian="Ma...[K] non c'è nessun posto per\nnascondersi qui.", spanish="Pero...[K] ¡si no hay ningún sitio\ndonde esconderse!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But...[K]there doesn't appear to be\nanyplace to hide here.", french="Mais...[K] il n'y a nulle part\noù se cacher ici.", german="Aber...[K] Es scheint hier nichts zu\ngeben, wo man sich verstecken könnte.", italian="Ma...[K] non sembra ci sia un\nposto per nascondersi qui.", spanish="Pero...[K] ¡si no hay ningún sitio\ndonde esconderse!"})
  else
  SkySceneKit.say({english="But...[K]there doesn't appear to be\nanywhere to hide here.", french="Mais...[K] il n'y a nulle part\noù se cacher ici.", german="Aber...[K] Es scheint hier nichts zu\ngeben, wo man sich verstecken könnte.", italian="Ma...[K] non vedo posti per\nnascondersi qui.", spanish="Pero...[K] ¡si no hay ningún sitio\ndonde esconderse!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" (What is this...?)", french=" (Qu'est-ce que c'est...?)", german=" (Was ist das?)", italian=" (Cos'è questo...?)", spanish=" (¿Qué ocurre?)"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" (An odd sense of foreboding!)", french=" (J'ai un étrange pressentiment!)", german=" (Eine seltsame Vorahnung!)", italian=" (Un presentimento...)", spanish="(¡Tengo un extraño\npresentimiento!)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="There are only rock walls\naround us.", french="Il n'y a que des parois de pierre\ntout autour de nous.", german="Um uns herum sind nur\nFelswände.", italian="Ci sono solo muri di roccia\nattorno a noi.", spanish=" Aquí solo hay paredes."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="There are only these rock walls\naround us.", french="Il n'y a que des parois de pierre\ntout autour de nous.", german="Da sind nur Felswände um uns\nherum.", italian="Ci sono solo questi muri di\nroccia attorno a noi.", spanish=" Aquí solo hay paredes."})
  else
  SkySceneKit.say({english="There are only rock walls\naround us.", french="Il n'y a que des parois de pierre\ntout autour de nous.", german="Da sind nur Felswände um uns\nherum.", italian="Ci sono solo muri di roccia\nattorno a noi.", spanish=" Aquí solo hay paredes."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="(That one glance I caught of\nthem...[K] I'm on the verge of remembering...)", french="(Je n'ai fait que les\napercevoir...[K] Ça va me revenir...)", german="(Das, was ich aus dem\nAugenwinkel von ihnen gesehen habe...[K] Ich bin\nkurz davor, mich zu erinnern.)", italian="(Li ho solo intravisti, ma...[K]\nMi sembra di ricordare...)", spanish="(Solo les vi un instante...[K]\nPero estoy a punto de recordarlo...)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_perappu, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english=" (That's it!)", french=" (J'y suis!)", german=" (Das ist es!)", italian=" (Ecco!)", spanish=" (¡Eso es!)"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="(When they attacked me last\ntime...)", french="(Quand ils m'ont attaqué\nla dernière fois...)", german="(Als sie mich das letzte Mal\nangegriffen haben...)", italian="(Quando mi hanno attaccato\nl'ultima volta...)", spanish="(Cuando me atacaron la última\nvez...)"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="(They seemed to appear out of\nnowhere.)", french="(... c'est comme s'ils avaient\nsurgi de nulle part.)", german=" (Sie erschienen aus dem Nichts.)", italian=" (Sono come comparsi dal nulla.)", spanish=" (Aparecieron como por encanto.)"})
  pcall(function() UI:SetSpeaker(npc_npc_perappu) end)
  SkySceneKit.say({english="(But where they really appeared\nfrom was...)", french="(Mais en fait, ils sont arrivés\nde...)", german=" (Aber tatsächlich kamen sie...)", italian=" (Ma in realtà sono apparsi da...)", spanish="(Y se abalanzaron hacia mí\ndesde...)"})
  -- message_Close
  -- SetAnimation(30) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GAME:FadeOut(false, 15)
  SkySceneKit.cleanup_npcs()
end
