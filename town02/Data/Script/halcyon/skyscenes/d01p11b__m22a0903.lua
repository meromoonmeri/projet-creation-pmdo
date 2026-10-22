-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11B/m22a0903.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V01P03C) [décor sub chargé: Sub_v01p03c]
  -- back_SetGround(LEVEL_D01P11B) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera2_SetPositionMark(Position<'m0', 33, 9.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  SkySubScreen.Show("v01p03c", 30, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  -- bgm2_PlayFadeIn(BGM_OCEAN1) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:FadeIn(30)
  -- GAP: BGM BGM_ON_THE_BEACH_AT_DUSK non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I remember...[K] I was too scared\nto get it back by myself.", french="Je me souviens...[K] J'étais trop\neffrayé pour aller le récupérer tout seul.", german="Ich erinnere mich...[K] Ich hatte zu\nviel Angst, um es selbst zurückzuholen.", italian="Mi ricordo che...[K] ero troppo\nspaventato per riprendermelo da solo.", spanish="Todavía me acuerdo...[K] Estaba\ndemasiado asustado para intentar recuperarla."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I remember...[K] I was too scared\nto get it back.", french="Je me souviens...[K] J'étais trop\neffrayé pour aller le récupérer tout seul.", german="Ich erinnere mich...[K] Ich hatte zu\nviel Angst, um es zurückzuholen.", italian="Mi ricordo che...[K] ero troppo\nspaventato per provare a riprendermelo.", spanish="Todavía me acuerdo...[K] Estaba\ndemasiado asustado para intentar recuperarla."})
  else
  SkySceneKit.say({english="I remember...[K] I was too scared\nto go get it back.", french="Je me souviens...[K] J'étais trop\neffrayée pour aller le récupérer toute seule.", german="Ich erinnere mich...[K] Ich hatte zu\nviel Angst, um es zurückzuholen.", italian="Mi ricordo che...[K] ero troppo\nspaventata per provare a riprendermelo.", spanish="Todavía me acuerdo...[K] Estaba\ndemasiado asustada para intentar recuperarla."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You made me feel brave then,\n[hero].", french="C'est toi qui m'as redonné\ncourage à l'époque, [hero].", german="Durch dich habe ich mich mutig\ngefühlt, [hero].", italian="In quell'occasione mi hai dato\nil coraggio, [hero].", spanish="Hiciste que me sintiera valiente\nen aquella ocasión, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You gave me courage then,\n[hero].", french="C'est toi qui m'as redonné\ncourage à l'époque, [hero].", german="Du hast mir damals Mut gegeben,\n[hero].", italian="In quell'occasione mi hai infuso\nil coraggio, [hero].", spanish="Me diste valor en aquella\nocasión, [hero]."})
  else
  SkySceneKit.say({english="You gave me courage then,\n[hero].", french="C'est toi qui m'as redonné\ncourage à l'époque, [hero].", german="Du hast mir damals Mut gegeben,\n[hero].", italian="In quell'occasione mi hai dato\nil coraggio, [hero].", spanish="Me diste valor en aquella\nocasión, [hero]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="You know, that was how we\nstarted, wasn't it?", french="Tu te souviens? C'est comme ça\nque tout a commencé entre nous.", german="So hat das damals mit uns\nangefangen, weißt du noch?", italian="Sai, è stato così che è\nnata la nostra squadra.", spanish=" Así fue como nació este equipo."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="You know, that was how we\nreally started as a team.", french="Tu te souviens? C'est comme ça\nque tout a commencé entre nous.", german="So wurden wir damals zu einem\nrichtigen Team, weißt du?", italian="Sai, è stato così che siamo\ndavvero diventati una squadra.", spanish=" Así fue como nació este equipo."})
  else
  SkySceneKit.say({english="You know, that was how we\nreally started as a team.", french="Tu te souviens? C'est comme ça\nque tout a commencé entre nous.", german="So wurden wir damals zu einem\nrichtigen Team, weißt du?", italian="Sai, è stato così che è nata\nla nostra squadra.", spanish=" Así fue como nació este equipo."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Getting back this Relic Fragment\nwas Team [team:]'s first adventure.", french="Récupérer mon Fragment\nde Relique a été la première aventure\nde l'Equipe [team:].", german="Dieses Reliktfragment\nzurückzuholen... Das war das erste Abenteuer\nfür Team [team:].", italian="Riprendersi il Frammento Antico\nè stata la prima avventura del Team\n[team:].", spanish="Recuperar la Reliquia de Piedra\nfue la primera aventura del [CS:X]Equipo[CR]\n[team:]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Getting back this Relic Fragment\nwas Team [team:]'s first adventure.", french="Récupérer mon Fragment\nde Relique a été la première aventure\nde l'Equipe [team:].", german="Dieses Reliktfragment\nzurückzuholen... Das war das erste Abenteuer\nfür Team [team:].", italian="Riprendersi il Frammento Antico\nè stata la prima avventura del Team\n[team:].", spanish="Recuperar la Reliquia de Piedra\nfue la primera aventura del [CS:X]Equipo[CR]\n[team:]."})
  else
  SkySceneKit.say({english="Getting back this Relic Fragment\nwas Team [team:]'s first adventure.", french="Récupérer mon Fragment\nde Relique a été la première aventure\nde l'Equipe [team:].", german="Dieses Reliktfragment\nzurückzuholen... Das war das erste Abenteuer\nfür Team [team:].", italian="Riprendersi il Frammento Antico\nè stata la prima avventura del Team\n[team:].", spanish="Recuperar la Reliquia de Piedra\nfue la primera aventura del [CS:X]Equipo[CR]\n[team:]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="And now, we're using the same\nRelic Fragment so we can go to the [CS:P]Hidden\nLand[CR].", french="Et voilà qu'on va se servir\ndu même Fragment de Relique pour atteindre\nles [CS:P]Terres Illusoires[CR].", german="Und jetzt verwenden wir\ndasselbe Reliktfragment, um zum\n[CS:P]Verborgenen Land[CR] zu gelangen.", italian="E adesso, stiamo usando quello\nstesso Frammento Antico per andare nella\n[CS:P]Terra Nascosta[CR].", spanish="Y ahora, estamos usando esa\nmisma reliquia para llegar a la [CS:P]Tierra Oculta[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="And now, we're using the same\nRelic Fragment so we can go to the [CS:P]Hidden\nLand[CR].", french="Et voilà qu'on va se servir\ndu même Fragment de Relique pour atteindre\nles [CS:P]Terres Illusoires[CR].", german="Und jetzt verwenden wir\ndasselbe Reliktfragment, um zum\n[CS:P]Verborgenen Land[CR] zu gelangen.", italian="E adesso, stiamo usando quello\nstesso Frammento Antico per andare nella\n[CS:P]Terra Nascosta[CR].", spanish="Y ahora, estamos usando esa\nmisma reliquia para llegar a la [CS:P]Tierra Oculta[CR]."})
  else
  SkySceneKit.say({english="And now, we're using the same\nRelic Fragment so we can go to the [CS:P]Hidden\nLand[CR].", french="Et voilà qu'on va se servir\ndu même Fragment de Relique pour atteindre\nles [CS:P]Terres Illusoires[CR].", german="Und jetzt verwenden wir\ndasselbe Reliktfragment, um zum\n[CS:P]Verborgenen Land[CR] zu gelangen.", italian="E adesso, stiamo usando quello\nstesso Frammento Antico per andare nella\n[CS:P]Terra Nascosta[CR].", spanish="Y ahora, estamos usando esa\nmisma reliquia para llegar a la [CS:P]Tierra Oculta[CR]."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It's strange when you think\nabout it.", french=" C'est étrange quand on y pense.", german="Seltsam, wenn man so darüber\nnachdenkt.", italian=" È strano quando ci pensi.", spanish=" Si lo piensas es muy extraño."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If you think about it, it's kind\nof strange.", french=" C'est étrange quand on y pense.", german="Seltsam, wenn man so darüber\nnachdenkt.", italian=" Se ci pensi, è così strano...", spanish=" Si lo piensas es muy extraño."})
  else
  SkySceneKit.say({english="If you think about it, it's kind\nof strange.", french=" C'est étrange quand on y pense.", german="Seltsam, wenn man so darüber\nnachdenkt.", italian=" Se ci pensi, è così strano...", spanish=" Si lo piensas es muy extraño."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That's true!)", french="(C'est vrai!)", german="(Das stimmt!)", italian="(È vero!)", spanish="(¡Es verdad!)"})
  else
  SkySceneKit.say({english="(That's true!)", french="(C'est vrai!)", german="(Das stimmt!)", italian="(È vero!)", spanish="(¡Es verdad!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(My adventures with [partner]...)", french="(Mes aventures avec [partner]...)", german="(Meine Abenteuer mit [partner]...)", italian="(Le mie avventure con [partner]...)", spanish="(Mis aventuras con [partner]...)"})
  else
  SkySceneKit.say({english="(My adventures with [partner]...)", french="(Mes aventures avec [partner]...)", german="(Meine Abenteuer mit [partner]...)", italian="(Le mie avventure con [partner]...)", spanish="(Mis aventuras con [partner]...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(and searching for the [CS:P]Hidden Land[CR]...)", french="(... et notre quête des [CS:P]Terres Illusoires[CR]...)", german="(Und die Suche nach dem [CS:P]Verborgenen Land[CR]...)", italian="(La ricerca della [CS:P]Terra Nascosta[CR]...)", spanish="(Y la búsqueda de la [CS:P]Tierra Oculta[CR]...)"})
  else
  SkySceneKit.say({english="(and searching for the [CS:P]Hidden Land[CR]...)", french="(... et notre quête des [CS:P]Terres Illusoires[CR]...)", german="(Und die Suche nach dem [CS:P]Verborgenen Land[CR]...)", italian="(La ricerca della [CS:P]Terra Nascosta[CR]...)", spanish="(Y la búsqueda de la [CS:P]Tierra Oculta[CR]...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(The Relic Fragment was the start of both!)", french="(Le Fragment de Relique est à l'origine\nde tout!)", german="(Beides begann mit dem Reliktfragment!)", italian="(Il Frammento Antico ha dato il via a entrambe\nle cose!)", spanish="(¡La Reliquia de Piedra ha sido el detonante\nde ambas cosas!)"})
  else
  SkySceneKit.say({english="(The Relic Fragment was the start of both!)", french="(Le Fragment de Relique est à l'origine\nde tout!)", german="(Beides begann mit dem Reliktfragment!)", italian="(Il Frammento Antico ha dato il via a entrambe\nle cose!)", spanish="(¡La Reliquia de Piedra ha sido el detonante\nde ambas cosas!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" This awesome sunset...", french=" Ce superbe coucher de soleil...", german="Dieser unglaubliche\nSonnenuntergang...", italian=" Questo fantastico tramonto...", spanish=" Esta increíble puesta de sol..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" This beautiful sunset...", french=" Ce superbe coucher de soleil...", german=" Dieser schöne Sonnenuntergang...", italian=" Questo bellissimo tramonto...", spanish=" Esta espectacular puesta de sol..."})
  else
  SkySceneKit.say({english=" This pretty sunset...", french=" Ce superbe coucher de soleil...", german="Dieser hübsche\nSonnenuntergang...", italian=" Questo bel tramonto...", spanish=" Esta hermosa puesta de sol..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It will be lost if the planet's\nparalysis can't be stopped.", french="... il sera perdu si on n'empêche\npas la Paralysie de la Planète.", german="Ihn wird es nicht mehr geben,\nwenn die Lähmung des Planeten nicht\naufgehalten werden kann.", italian="... andrà perduto se non\nfermeremo la paralisi del pianeta.", spanish="Se perderá si no conseguimos\nfrenar la parálisis del planeta."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It will be lost if the planet's\nparalysis can't be stopped.", french="... il sera perdu si on n'empêche\npas la Paralysie de la Planète.", german="Ihn wird es nicht mehr geben,\nwenn die Lähmung des Planeten nicht\naufgehalten werden kann.", italian="... andrà perduto se non\nfermeremo la paralisi del pianeta.", spanish="Se perderá si no conseguimos\ndetener la parálisis del planeta."})
  else
  SkySceneKit.say({english="It will be lost if the planet's\nparalysis can't be stopped.", french="... il sera perdu si on n'empêche\npas la Paralysie de la Planète.", german="Ihn wird es nicht mehr geben,\nwenn die Lähmung des Planeten nicht\naufgehalten werden kann.", italian="... andrà perduto se non\nfermeremo la paralisi del pianeta.", spanish="Se perderá si no conseguimos\ndetener la parálisis del planeta."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We have to prevent that![K]\nWe can't waste time finding the [CS:P]Hidden Land[CR].", french="On doit faire quelque chose![K]\nOn ne peut pas perdre une seconde dans\nnotre quête des [CS:P]Terres Illusoires[CR].", german="Wir müssen das verhindern![K]\nWir dürfen keine Zeit verlieren, um das\n[CS:P]Verborgene Land[CR] zu finden.", italian="Dobbiamo evitarlo![K] Dobbiamo\ntrovare la [CS:P]Terra Nascosta[CR] il più presto\npossibile.", spanish="¡Tenemos que evitarlo![K]\n¡Hay que encontrar la [CS:P]Tierra Oculta[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We have to stop that![K] We can't\nwaste any time finding the [CS:P]Hidden Land[CR].", french="On doit faire quelque chose![K]\nOn ne peut pas perdre une seconde dans\nnotre quête des [CS:P]Terres Illusoires[CR].", german="Wir müssen das verhindern![K]\nWir haben keine Zeit zu verlieren, wenn wir\ndas [CS:P]Verborgene Land[CR] finden wollen.", italian="Dobbiamo evitarlo![K] Dobbiamo\ntrovare la [CS:P]Terra Nascosta[CR] il più presto\npossibile.", spanish="¡Tenemos que evitarlo![K]\n¡Hay que encontrar la [CS:P]Tierra Oculta[CR]!"})
  else
  SkySceneKit.say({english="We have to stop that![K] We can't\nwaste any time finding the [CS:P]Hidden Land[CR].", french="On doit faire quelque chose![K]\nOn ne peut pas perdre une seconde dans\nnotre quête des [CS:P]Terres Illusoires[CR].", german="Wir müssen das verhindern![K]\nWir haben keine Zeit zu verlieren, wenn wir\ndas [CS:P]Verborgene Land[CR] finden wollen.", italian="Dobbiamo evitarlo![K] Dobbiamo\ntrovare la [CS:P]Terra Nascosta[CR] il più presto\npossibile.", spanish="¡Tenemos que evitarlo![K]\n¡Hay que encontrar la [CS:P]Tierra Oculta[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  GAME:WaitFrames(30)
  -- SetOutputAttribute(2) [neutre/état moteur]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(8), p.Y+(8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  -- GAP: se_Play(8710) — id SE NDS sans portage PMDO identifié
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(10)
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(-8), p.Y+(-8), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(20)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We have to do good tomorrow,\n[hero]!", french="On doit se surpasser demain,\n[hero]!", german="Wir müssen morgen das Beste\naus uns herausholen, [hero]!", italian="Domani dobbiamo dare il meglio,\n[hero]!", spanish="¡Mañana no podemos fallar,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We have to do good tomorrow,\n[hero]!", french="On doit se surpasser demain,\n[hero]!", german="Wir müssen morgen das Beste\naus uns herausholen, [hero]!", italian="Domani dobbiamo dare il meglio,\n[hero]!", spanish="¡Mañana hay que echar\nel resto, [hero]!"})
  else
  SkySceneKit.say({english="We have to do good tomorrow,\n[hero]!", french="On doit se surpasser demain,\n[hero]!", german="Wir müssen morgen das Beste\naus uns herausholen, [hero]!", italian="Domani dobbiamo dare il meglio,\n[hero]!", spanish="¡Mañana hay que echar\nel resto, [hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That's right. We have to try hard.)", french="(C'est bien vrai. On doit donner le meilleur\nde nous-mêmes.)", german="(Das stimmt. Wir müssen uns sehr\nanstrengen.)", italian="(È vero. Dobbiamo mettercela tutta.)", spanish="(Es cierto. Hay que esforzarse.)"})
  else
  SkySceneKit.say({english="(That's right. We have to try hard.)", french="(C'est bien vrai. On doit donner le meilleur\nde nous-mêmes.)", german="(Das stimmt. Wir müssen uns sehr\nanstrengen.)", italian="(È vero. Dobbiamo mettercela tutta.)", spanish="(Es cierto. Hay que esforzarse.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I must fulfill the mission that I had before\nlosing my memory.)", french="(Je dois remplir la mission dont j'étais chargé\navant de perdre la mémoire.)", german="(Ich muss die Mission zu Ende bringen, die ich\nhatte, bevor ich mein Gedächtnis verlor.)", italian="(Devo portare a termine la missione che\navevo intrapreso prima di perdere la\nmemoria.)", spanish="(Debo cumplir la misión que tenía antes de\nperder la memoria.)"})
  else
  SkySceneKit.say({english="(I must fulfill the mission that I had before\nlosing my memory.)", french="(Je dois remplir la mission dont j'étais\nchargée avant de perdre la mémoire.)", german="(Ich muss die Mission zu Ende bringen, die ich\nhatte, bevor ich mein Gedächtnis verlor.)", italian="(Devo portare a termine la missione che\navevo intrapreso prima di perdere la\nmemoria.)", spanish="(Debo cumplir la misión que tenía antes de\nperder la memoria.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(My mission with [CS:N]Grovyle[CR]...)", french="(Ma mission avec [CS:N]Massko[CR]...)", german="(Meine Mission mit [CS:N]Reptain[CR]...)", italian="(La mia missione con [CS:N]Grovyle[CR]...)", spanish="(El objetivo que compartía con [CS:N]Grovyle[CR]...)"})
  else
  SkySceneKit.say({english="(My mission with [CS:N]Grovyle[CR]...)", french="(Ma mission avec [CS:N]Massko[CR]...)", german="(Meine Mission mit [CS:N]Reptain[CR]...)", italian="(La mia missione con [CS:N]Grovyle[CR]...)", spanish="(El objetivo que compartía con [CS:N]Grovyle[CR]...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(A mission to help the Pokémon of this world\nand those of the future...)", french="(Venir en aide aux Pokémon de ce monde\net du futur...)", german="(Eine Mission, um Pokémon dieser und der\nzukünftigen Welt zu helfen...)", italian="(Una missione per aiutare sia i Pokémon di\nquesto mondo che quelli del futuro...)", spanish="(Una misión para ayudar a los Pokémon de\neste mundo y a los del futuro...)"})
  else
  SkySceneKit.say({english="(A mission to help the Pokémon of this world\nand those of the future...)", french="(Venir en aide aux Pokémon de ce monde\net du futur...)", german="(Eine Mission, um Pokémon dieser und der\nzukünftigen Welt zu helfen...)", italian="(Una missione per aiutare sia i Pokémon di\nquesto mondo che quelli del futuro...)", spanish="(Una misión para ayudar a los Pokémon de\neste mundo y a los del futuro...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(120) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh? Hey, [hero]...", french=" Hein? Dis, [hero]...", german=" Ähem? Hey, [hero]...", italian=" Eh? Ehi, [hero]...", spanish=" ¿Qué? Mira, [hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What? Hey, [hero]...", french=" Hein? Dis, [hero]...", german=" Was? Hey, [hero]...", italian=" Cosa? Ehi, [hero]...", spanish=" ¿Qué? Mira, [hero]..."})
  else
  SkySceneKit.say({english=" What? Say, [hero]...", french=" Hein? Dis, [hero]...", german=" Was? Sag mal, [hero]...", italian=" Cosa? Guarda, [hero]...", spanish=" ¿Qué? Mira, [hero]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" That...[K] What is that?", french="Regarde ça...[K] Qu'est-ce que\nc'est?", german=" Dieses...[K] Was ist das?", italian=" Chi...[K] Chi è quello?", spanish=" Eso de ahí...[K] ¿Qué es eso?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" That...[K] What is that?", french="Regarde ça...[K] Qu'est-ce que\nc'est?", german=" Dieses...[K] Was ist das?", italian=" Chi...[K] Chi è quello?", spanish=" Eso de ahí...[K] ¿Qué es eso?"})
  else
  SkySceneKit.say({english=" That...[K] What is that?", french="Regarde ça...[K] Qu'est-ce que\nc'est?", german=" Dieses...[K] Was ist das?", italian=" Chi...[K] Chi è quello?", spanish=" Eso de ahí...[K] ¿Qué es eso?"})
  end
  -- message_Close
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetGround(V22P01A) [décor sub chargé: Sub_v22p01a]
  -- back2_SetBackEffect(2) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  -- supervision_Acting(1) [neutre/état moteur]
  -- MovePositionMark OBJECT_V22P01A1_289 [cible sans placement SSA zone: mouvement non joué]
  -- camera2_SetPositionMark(Position<'m2', 19, 9.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v22p01a", 30, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V22P01A1_289) [routine d'objet NDS non simulée - documenté]
  -- MovePositionOffset<object OBJECT_V22P01A1_289> [prop décor NDS, géré par le rendu du ground]
  SkySubScreen.Hide(15) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetGround(V22P02A) [décor sub chargé: Sub_v22p02a]
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(2) [neutre/état moteur]
  -- supervision_Acting(3) [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  -- MovePositionMark OBJECT_V22P02A1_290 [cible sans placement SSA zone: mouvement non joué]
  -- MovePositionMark OBJECT_V22P02A2_294 [cible sans placement SSA zone: mouvement non joué]
  -- camera2_SetPositionMark(Position<'m5', 25, 9.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- back2_SetBackEffect(2) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  SkySubScreen.Show("v22p02a", 15, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V22P02A1_290) [routine d'objet NDS non simulée - documenté]
  -- MovePositionOffset<object OBJECT_V22P02A1_290> [prop décor NDS, géré par le rendu du ground]
  -- MovePositionOffset<object OBJECT_V22P02A2_294> [prop décor NDS, géré par le rendu du ground]
  SkySubScreen.Hide(15) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetGround(V22P01A) [décor sub chargé: Sub_v22p01a]
  -- camera2_SetPositionMark(Position<'m6', 19, 9.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- back2_SetBackEffect(2) [effet du canal sub NDS: nappe Sub_ statique, effet non simulé - documenté]
  -- supervision_RemoveActing(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_RemoveActing(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(1) [neutre/état moteur]
  -- SetPositionMark OBJECT_V22P01A1_289 [cible sans placement SSA zone: placement non joué]
  -- MovePositionMark OBJECT_V22P01A1_289 [cible sans placement SSA zone: mouvement non joué]
  SkySubScreen.Show("v22p01a", 15, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(2) -- join WaitExecuteObject(OBJECT_V22P01A1_289) [routine d'objet NDS non simulée - documenté]
  -- MovePositionOffset<object OBJECT_V22P01A1_289> [prop décor NDS, géré par le rendu du ground]
  SkySubScreen.Hide(30) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- supervision_RemoveActing(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- back2_SetGround(V01P03C) [décor sub chargé: Sub_v01p03c]
  -- camera2_SetPositionMark(Position<'m9', 33, 9.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v01p03c", 30, true) -- screen2_FadeIn: BOTH_FOCUS (timeline ROM)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What could it be...?", french=" Qu'est-ce que ça peut bien être?", german=" Was könnte das sein?", italian=" Chi potrebbe essere...?", spanish=" ¿Qué podrá ser...?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What could it be...?", french=" Qu'est-ce que ça peut bien être?", german=" Was könnte das sein?", italian=" Chi potrebbe essere...?", spanish=" ¿Qué podrá ser...?"})
  else
  SkySceneKit.say({english=" What could it be...?", french=" Qu'est-ce que ça peut bien être?", german=" Was könnte das sein?", italian=" Chi potrebbe essere...?", spanish=" ¿Qué podrá ser...?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="It seems like it's swimming\nacross the sunset...", french="On dirait que c'est en train\nde nager devant le coucher de soleil...", german="Es sieht so aus, als schwömme\nes durch den Sonnenuntergang...", italian="Sembra che stia attraversando a\nnuoto la luce del tramonto...", spanish="Es como si nadara atravesando\nel ocaso..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It looks like it's swimming\nacross the sunset...", french="On dirait que c'est en train\nde nager devant le coucher de soleil...", german="Es sieht so aus, als schwömme\nes durch den Sonnenuntergang...", italian="Sembra che stia attraversando a\nnuoto la luce del tramonto...", spanish="Es como si nadara atravesando\nel ocaso..."})
  else
  SkySceneKit.say({english="It looks like it's swimming\nacross the sunset...", french="On dirait que c'est en train\nde nager devant le coucher de soleil...", german="Es sieht so aus, als schwömme\nes durch den Sonnenuntergang...", italian="Sembra che stia attraversando a\nnuoto la luce del tramonto...", spanish="Es como si nadara atravesando\nel ocaso..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I think it's a Pokémon...", french=" Je crois que c'est un Pokémon...", german=" Ich glaube, es ist ein Pokémon...", italian=" Penso che sia un Pokémon...", spanish=" Creo que es un Pokémon..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I think it's a Pokémon...", french=" Je crois que c'est un Pokémon...", german=" Ich glaube, es ist ein Pokémon...", italian=" Penso che sia un Pokémon...", spanish=" Creo que es un Pokémon..."})
  else
  SkySceneKit.say({english=" I think it's a Pokémon...", french=" Je crois que c'est un Pokémon...", german=" Ich glaube, es ist ein Pokémon...", italian=" Penso che sia un Pokémon...", spanish=" Creo que es un Pokémon..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Well...[K]that's a little strange...", french=" Eh bien...[K] c'est bizarre...", german="Hm...[K] Das ist irgendwie\nseltsam...", italian=" Beh...[K] È proprio strano...", spanish=" Pues...[K] Qué raro, ¿no?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Well...[K]that's a little strange...", french=" Eh bien...[K] c'est bizarre...", german="Hm...[K] Das ist irgendwie\nseltsam...", italian=" Beh...[K] È proprio strano...", spanish=" Pues...[K] Qué raro, ¿no?"})
  else
  SkySceneKit.say({english=" Well...[K]that's a little strange...", french=" Eh bien...[K] c'est bizarre...", german="Hm...[K] Das ist irgendwie\nseltsam...", italian=" Beh...[K] È proprio strano...", spanish=" Pues...[K] Qué raro, ¿no?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" The sun's almost gone.", french=" Le soleil a presque disparu.", german=" Die Sonne ist fast weg.", italian=" Il sole se n'è quasi andato.", spanish=" El sol casi se ha puesto."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" The sun's almost gone.", french=" Le soleil a presque disparu.", german=" Die Sonne ist fast weg.", italian=" Il sole se n'è quasi andato.", spanish=" El sol casi se ha puesto."})
  else
  SkySceneKit.say({english=" The sun's almost gone.", french=" Le soleil a presque disparu.", german=" Die Sonne ist fast weg.", italian=" Il sole se n'è quasi andato.", spanish=" El sol casi se ha puesto."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Let's go back to the guild soon.", french=" Retournons vite à la Guilde.", german="Lass uns bald zur Gilde\nzurückgehen.", italian=" Torniamo in fretta alla Gilda.", spanish="Deberíamos volver pronto\nal [CS:N]Pokégremio[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We should go back to the\nguild soon.", french=" Retournons vite à la Guilde.", german="Wir sollten bald zur Gilde\nzurückgehen.", italian="Dobbiamo tornare in fretta alla\nGilda.", spanish="Deberíamos volver pronto\nal [CS:N]Pokégremio[CR]."})
  else
  SkySceneKit.say({english="We should go back to the\nguild soon.", french=" Retournons vite à la Guilde.", german="Wir sollten bald zur Gilde\nzurückgehen.", italian="Dobbiamo tornare in fretta alla\nGilda.", spanish="Deberíamos volver pronto\nal [CS:N]Pokégremio[CR]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(15)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(160), p.Y+(0), false, 2) end
  GAME:WaitFrames(15)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(24), p.Y+(24), false, 2) end
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(136), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(90)
  pcall(function() GAME:MoveCamera(252, 180, 60, false) end) -- performer/caméra
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  local npc_npc_sukatanku = SkySceneKit.spawn_npc("skuntank", 184, 256, Direction.UpRight, "NPC_SUKATANKU")
  do local p=npc_npc_sukatanku.Position; GROUND:MoveToPosition(npc_npc_sukatanku, p.X+(32), p.Y+(-32), false, 2) end
  GAME:WaitFrames(10)
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 160, 264, Direction.UpRight, "NPC_ZUBATTO")
  do local p=npc_npc_zubatto.Position; GROUND:MoveToPosition(npc_npc_zubatto, p.X+(32), p.Y+(-32), false, 2) end
  GAME:WaitFrames(15)
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 176, 272, Direction.UpRight, "NPC_DOGAASU")
  do local p=npc_npc_dogaasu.Position; GROUND:MoveToPosition(npc_npc_dogaasu, p.X+(0), p.Y+(-32), false, 2) end
  GROUND:MoveToPosition(npc_npc_sukatanku, 280, 180, false, 2)
  GROUND:MoveToPosition(npc_npc_zubatto, 224, 180, false, 2)
  GROUND:MoveToPosition(npc_npc_dogaasu, 252, 200, false, 2)
  GROUND:EntTurn(npc_npc_zubatto, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" Chaw-haw-haw!", french=" Gnark gnark gnark!", german=" Cha-ha-ha!", italian=" Ahr-ahr-ahr!", spanish=" ¡Jua, jua, jua!"})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="The [CS:N]Krabby[CR] weren't around\nfor a good reason!", french="Il y a une bonne raison\nà l'absence des [CS:N]Krabby[CR]!", german="Die [CS:N]Krabby[CR] waren aus gutem\nGrund nicht hier!", italian="È chiaro che i [CS:N]Krabby[CR] non ci\nsono.", spanish="¡Por supuesto que no están\naquí los [CS:N]Krabby[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="They ran off! Scared of us!\nChaw-haw!", french="Ils ont pris la fuite! C'est nous\nqui leur avons fait peur! Gnark gnark!", german="Sie sind abgehauen! Aus Angst\nvor uns! Cha-ha!", italian="Sono scappati! Li abbiamo\nspaventati! Ahr-ahr!", spanish="¡Han salido pitando!\n¡Tenían miedo de nosotros! ¡Jua, jua!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" Whoa-ho-ho![K] But, Chief!", french="Mouarf mouarf mouarf![K]\nAu fait, chef!", german=" Whoahoho![K] Aber Boss!", italian=" Uooh-oh-oh![K] Ma, capo!", spanish=" ¡Jo, jo, jo![K] Pero... ¡Jefe!"})
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="That old-timer [CS:N]Torkoal[CR] wasn't\nlying to us, after all.", french="Ce vieux croulant de [CS:N]Chartor[CR]\nnous a pas menti, finalement.", german="Dieser Opa [CS:N]Qurtel[CR] hat uns\nwenigstens nicht angelogen.", italian="Quindi quel vecchietto di [CS:N]Torkoal[CR]\nnon ci stava mentendo.", spanish="Ese abuelete de [CS:N]Torkoal[CR] no\nnos mentía después de todo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Heh-heh![K] That junk we stole\nback then...", french="Hin hin![K] Ce rebut qu'on a volé\nl'autre fois...", german="Hehe![K] Dieser Schrott, den wir\ndamals gestohlen haben...", italian="Eh-eh![K] Quella roba che\nabbiamo rubato allora...", spanish="¡Jue, jue![K] Ese cascote que le\nquitamos aquella vez..."})
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="I didn't know it was going to\nbe something that valuable.", french="Je pensais pas qu'il finirait\npar prendre autant de valeur.", german="Ich wusste nicht, dass das mal\nso viel wert sein würde.", italian="Non pensavo proprio che potesse\navere un valore.", spanish="No sabía que iba a ser algo tan\nvalioso."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="So what? We'll get that Relic\nFragment from them one way or another.", french="Et alors? On le leur volera\nà nouveau, d'une façon ou d'une autre.", german="Na und? Wir kriegen das\nReliktfragment von ihnen so oder so.", italian="E allora? In un modo o nell'altro\nci prenderemo quel Frammento Antico.", spanish="¿Y qué? Ya conseguiremos esa\nReliquia de Piedra de una forma u otra."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="That means the [CS:P]Hidden Land[CR] is\ngoing to be explored by...", french="Ça signifie que la découverte\ndes [CS:P]Terres Illusoires[CR] sera à mettre\nà l'honneur...", german="Das bedeutet, das\n[CS:P]Verborgene Land[CR] wird erkundet von...", italian="Questo significa che la [CS:P]Terra[CR]\n[CS:P]Nascosta[CR] sta per essere esplorata...", spanish="Vamos, que esa [CS:P]Tierra Oculta[CR]\nserá explorada..."})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="None other than us, Team [CS:X]Skull[CR]!\nChaw-haw-haw!", french="... de personne d'autre que nous,\nl'Equipe [CS:X]Crâne[CR]! Gnark gnark gnark!", german="Von niemand anderem als uns,\nTeam [CS:X]Totenkopf[CR]!\nCha-ha-ha!", italian="... solo da noi, il Team [CS:X]Teschio[CR]!\nAhr-ahr-ahr!", spanish="Nada menos que por nosotros,\n¡el [CS:X]Equipo Calavera[CR]! ¡Jua, jua, jua!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" Whoa-ho-ho!", french=" Mouarf mouarf mouarf!", german=" Whoahoho!", italian=" Uooh-oh-oh!", spanish=" ¡Jo, jo, jo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Heh-heh-heh!", french=" Hin hin hin!", german=" Hehehe!", italian=" Eh-eh-eh!", spanish=" ¡Jue, jue, jue!"})
  -- message_Close
  SkySubScreen.Hide(90) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 90)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(60)
  SkySceneKit.cleanup_npcs()
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
