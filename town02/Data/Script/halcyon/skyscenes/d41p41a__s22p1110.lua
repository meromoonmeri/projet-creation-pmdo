-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D41P41A/s22p1110.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Hidden Highland.ogg", true) end)
  -- back_SetGround(LEVEL_D41P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...I...[K]I did that?)", french="(... J'ai...[K] j'ai fait ça, moi?)", german="(Das...[K] habe ich getan?)", italian="(L'ho davvero...[K] fatto?)", spanish="(Yo...[K] ¿Hice eso?)"})
  else
  SkySceneKit.say({english="(...I...[K]I did that?)", french="(... J'ai...[K] j'ai fait ça, moi?)", german="(Das...[K] habe ich getan?)", italian="(L'ho davvero...[K] fatto?)", spanish="(Yo...[K] ¿Hice eso?)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_daakurai = SkySceneKit.spawn_npc("darkrai", 280, 152, Direction.Down, "NPC_DAAKURAI")
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="I assumed what I did was\nsufficient.", french="Je suis parti du principe que j'en\navais fait assez.", german="Ich nahm an, es wäre genug\ngewesen.", italian="Pensavo che ciò che avevo fatto\nsarebbe stato sufficiente.", spanish="Creí que bastaría con eso\npara deteneros."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="I thought that I'd rendered you\nincapable of preventing the planet's paralysis.", french="Je pensais vous avoir rendus\nincapables d'empêcher la Paralysie de\nla Planète.", german="Ich dachte, ich hätte dich\nausgeschaltet, sodass du die Lähmung des\nPlaneten nicht mehr hättest aufhalten können.", italian="Pensavo di avervi resi\nincapaci di fermare la paralisi del pianeta.", spanish="Pensé que tras lo ocurrido\nserías incapaz de impedir la parálisis\ndel planeta."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="However...[K]I underestimated\nyour resourcefulness.", french="Pourtant...[K] j'ai sous-estimé\nvotre détermination.", german="Allerdings[K] scheine ich deine\nFindigkeit unterschätzt zu haben...", italian="Tuttavia...[K] devo avervi\nsottovalutati.", spanish="Sin embargo...[K] veo que te\nsubestimé."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="You met with [partner]...[K]\nAnd the two of you stopped the destruction of\n[CS:P]Temporal Tower[CR].", french="Tu as rencontré [partner]...\nEt ensemble, vous avez mis un terme à\nla destruction de la [CS:P]Tour du Temps[CR].", german="Du tatest dich mit [partner]\nzusammen...[K] Gemeinsam habt ihr die\nZerstörung des [CS:P]Zeitturms[CR] verhindert.", italian="Tu hai incontrato [partner],[K]\ne insieme avete prevenuto la distruzione della\n[CS:P]Torre del Tempo[CR].", spanish="Conociste a [partner]...[K]\nY lograsteis detener la destrucción\nde la [CS:P]Torre del Tiempo[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="Because I'd underestimated and\ndisregarded how much you would meddle...", french="Parce que je vous avais tous\nsous-estimés et comptés comme quantité\nnégligeable...", german="Ich habe eure Einmischung\nunterschätzt und vernachlässigt...", italian="Avendo sottovalutato quanto\navreste interferito...", spanish="Como os subestimé e hice caso\nomiso de vuestras capacidades..."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" My original plan ended in failure.", french="... ma stratégie initiale a\néchoué.", german="Und deshalb scheiterte mein\nursprünglicher Plan.", italian="... il mio piano originale si è\nrivelato un fallimento.", spanish="Mi plan original se desbarató\npor completo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  local npc_npc_kureseria = SkySceneKit.spawn_npc("cresselia", 280, 200, Direction.Up, "NPC_KURESERIA")
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" That's why...", french=" C'est pourquoi...", german=" Darum...", italian=" È per questo...", spanish=" Por eso..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="That's why you decided to get\nrid of [hero] and [partner] first\nthis time!", french="... c'est pourquoi tu as décidé\nde commencer par te débarrasser de\n[hero] et [partner], cette fois!", german="Darum wolltest du diesmal\nzuerst [hero] und [partner]\nbeseitigen!", italian="È per questo che hai deciso di\nsbarazzarti prima di [hero] e di\n[partner] questa volta!", spanish="Decidiste quitar de en medio a\n[hero] y a [partner]."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="So they wouldn't be an\nimpediment to your scheming!", french="Pour que personne ne vienne\ndéjouer tes plans machiavéliques!", german="Damit sie kein Hemmnis für\ndeine Pläne darstellen konnten!", italian="Volevi impedire che ti\nmettessero i bastoni tra le ruote!", spanish="¡Para que no frustraran tus\nplanes de nuevo!"})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="That's why you tried to break\ntheir spirit...[K] Even going so far as to use\nan impostor of me!", french="C'est pour cette raison que\ntu as essayé de les décourager...[K] en allant\njusqu'à créer un pantin à mon image!", german="Darum wolltest du ihren Willen\nbrechen...[K] Du gingst sogar so weit,\neine Imitation von mir zu verwenden!", italian="Ecco perché hai provato\na piegarne lo spirito...[K] Hai persino\nusato una falsa me stessa!", spanish="E intentaste minar su moral...[K]\n¡usando a una impostora!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(120) end)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" Even now...[K]you lured us here...", french="Et maintenant...[K] tu nous attires\nici...", german="Sogar jetzt[K] sind wir von dir\nhierher gelockt worden...", italian="Anche adesso...[K] ci aspettavi\nqui...", spanish="Incluso ahora, ¿verdad?[K] Nos\nhas traído aquí para lo mismo..."})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="So you could be rid of us all in\none fell swoop!", french="... de manière à éliminer\ntes trois adversaires d'un seul coup!", german="Damit du uns alle in einem\nAufwasch beseitigen kannst!", italian=" Per eliminarci in un colpo solo!", spanish="¡Para quitarnos de en medio\na todos de golpe!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="...[K]Very good. I did indeed\nintend to do just what you say.", french="...[K] Toutes mes félicitations.\nEn effet, c'est exactement ce que j'avais\nl'intention de faire.", german="...[K]Sehr gut. Ich habe das\ntatsächlich so vorgesehen, wie von dir\nbeschrieben.", italian="...[K] Molto brava. È esattamente\nciò che volevo fare.", spanish="Sí...[K] En efecto. Esa era mi\nintención."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(4), 13, false) end) -- MovePositionOffset performer/caméra
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_kureseria.Position; GROUND:MoveToPosition(npc_npc_kureseria, p.X+(0), p.Y+(4), false, 1) end -- SlidePositionOffset
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(4), false, 1) end -- SlidePositionOffset
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(4), false, 1) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" But...[K]I've had a change of heart.", french=" Mais...[K] j'ai changé d'avis.", german="Aber...[K] Ich hatte einen\nSinneswandel.", italian=" Ma...[K] ho cambiato idea.", spanish=" Pero...[K] he cambiado de opinión."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "exclaim", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" So...[hero]...[partner].", french="Donc... [hero]...\n[partner].", german=" So, [hero], [partner].", italian=" [hero] e [partner].", spanish=" [hero]... [partner]..."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="Both of you are brave. You've\nshown great initiative.", french="Vous avez prouvé votre courage\net votre grande valeur.", german="Ihr seid beide mutig. Ihr habt\ngroßen Einsatz gezeigt.", italian="Avete dimostrato di avere\ncoraggio e spirito d'iniziativa.", spanish="Sois valientes y, en repetidas\nocasiones, habéis demostrado tener\niniciativa."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="To be rid of you forever...[K]\nSeems like a tragic waste.", french="Vous éliminer pour toujours...[K]\nme semble un terrible gâchis.", german="Euch für immer los zu sein,[K]\nwäre eine schlimme Verschwendung.", italian="Sbarazzarmi di voi per\nsempre...[K] mi sembra un tragico spreco.", spanish="Quitaros de en medio...[K] sería\nlamentable."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="You've both shown so much\npromise...[K] Why not join me?", french="Vous avez montré des talents\nfort prometteurs...[K] Que diriez-vous de vous\njoindre à moi?", german="Ihr habt beide vielversprechende\nAnsätze gezeigt...[K] Wie wäre es, wenn wir\nzusammenarbeiten würden?", italian="Avete del potenziale...[K]\nPerché non passate dalla mia parte?", spanish="Tenéis tantas aptitudes...[K] ¿Por\nqué no os unís a mí?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_PLANETS_PARALYSIS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?", french=" Pardon?", german=" Wie bitte?", italian=" Eh?", spanish=" ¿Qué?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?", french=" Pardon?", german=" Was?", italian=" Cosa?", spanish=" ¿Qué?"})
  else
  SkySceneKit.say({english=" What?", french=" Pardon?", german=" Was?", italian=" Cosa?", spanish=" ¿Qué?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="Why not join me...[K]in ruling a\nworld full of darkness?", french="Rejoignez-moi...[K] et dominons\nensemble un monde plongé à jamais dans\nl'ombre.", german="Warum steht ihr mir nicht zur\nSeite...[K] Bei der Beherrschung einer Welt\nvoller Dunkelheit?", italian="Perché non vi unite a me?[K]\nPotremmo regnare su un mondo immerso\nnell'oscurità.", spanish="¿Por qué no os unís a mí?[K]\nPodríais gobernar conmigo el mundo\nde la oscuridad."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  else
  SkySceneKit.say({english=" What?!", french=" Quoi?!", german=" Was?!?", italian=" Cosa?!", spanish=" ¡¿Qué?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(R-rule the world...[K]with [CS:N]Darkrai[CR]?!)", french="(Dominer le monde...[K] avec [CS:N]Darkrai[CR]?!)", german="(D-die Welt beherrschen...[K] mit [CS:N]Darkrai[CR]?)", italian="(D-Dominare il mondo...[K] con [CS:N]Darkrai[CR]?!)", spanish="(¡¿Gobernar el mundo...[K] con [CS:N]Darkrai[CR]?!)"})
  else
  SkySceneKit.say({english="(R-rule the world...[K]with [CS:N]Darkrai[CR]?!)", french="(Dominer le monde...[K] avec [CS:N]Darkrai[CR]?!)", german="(D-die Welt beherrschen...[K] mit [CS:N]Darkrai[CR]?)", italian="(D-Dominare il mondo...[K] con [CS:N]Darkrai[CR]?!)", spanish="(¡¿Gobernar el mundo...[K] con [CS:N]Darkrai[CR]?!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="It is entirely possible if we\nthree band together.", french="C'est tout à fait faisable si\nnous unissons nos forces.", german="Es ist absolut möglich, wenn wir\ndrei uns zusammenschließen.", italian="Se noi tre uniamo le forze\npotremmo farcela davvero.", spanish=" Si nos aliamos, sería posible."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" Well?[K] Will you join me?", french="Eh bien?[K] Acceptez-vous de vous\njoindre à moi?", german=" Nun?[K] Macht ihr mit?", italian=" Ebbene?[K] Vi unirete a me?", spanish=" ¿Y bien?[K] ¿Qué me decís?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_kureseria, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" Oh, [hero]! [partner]!", french=" Oh, [hero]! [partner]!", german=" Oh, [hero]! [partner]!", italian=" Oh, [hero]! [partner]!", spanish="¡Oh, [hero]!\n¡[partner]!"})
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" Don't believe his lies!", french=" Ne le croyez pas, il ment!", german=" Glaubt seinen Lügen nicht!", italian=" Non credete alle sue menzogne!", spanish=" ¡No hagáis caso de sus mentiras!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  else
  SkySceneKit.say({english=" ..................", french=" ..................", german=" ..................", italian=" ..................", spanish=" ..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="[partner]![K] Are you\nlistening?!", french=" [partner]![K] Tu m'entends?!", german=" [partner]![K] Hörst du mich?!?", italian="[partner]![K] Mi stai\nascoltando?!", spanish="¡[partner]![K] ¡¿Me estás\nescuchando?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" ...[K]Maybe [CS:N]Darkrai[CR]...[K]is right.", french="...[K] Peut-être que [CS:N]Darkrai[CR]...[K]\na raison.", german=" ...[K]Vielleicht hat [CS:N]Darkrai[CR]...[K] recht.", italian=" ...[K] Forse [CS:N]Darkrai[CR]...[K] ha ragione.", spanish="Tal vez...[K] Tal vez [CS:N]Darkrai[CR]...[K]\ntenga razón."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" ...[K]Maybe [CS:N]Darkrai[CR]...[K]is right.", french="...[K] Peut-être que [CS:N]Darkrai[CR]...[K]\na raison.", german=" ...[K]Vielleicht hat [CS:N]Darkrai[CR]...[K] recht.", italian=" ...[K] Forse [CS:N]Darkrai[CR]...[K] ha ragione.", spanish="Tal vez...[K] Tal vez [CS:N]Darkrai[CR]...[K]\ntenga razón."})
  else
  SkySceneKit.say({english=" ...[K]Maybe [CS:N]Darkrai[CR]...[K]is right.", french="...[K] Peut-être que [CS:N]Darkrai[CR]...[K]\na raison.", german=" ...[K]Vielleicht hat [CS:N]Darkrai[CR]...[K] recht.", italian=" ...[K] Forse [CS:N]Darkrai[CR]...[K] ha ragione.", spanish="Tal vez...[K] Tal vez [CS:N]Darkrai[CR]...[K]\ntenga razón."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Realized") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" No, [partner]!", french=" Non, [partner]!", german=" Nein, [partner]!", italian=" No, [partner]!", spanish=" ¡No, [partner]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Who are we kidding? We don't\nstand a chance against [CS:N]Darkrai[CR] anyway!", french="Ne nous faisons pas d'illusions!\nDe toute façon, on n'a aucune chance contre\n[CS:N]Darkrai[CR]!", german="Wem wollen wir etwas\nvormachen? Wir haben sowieso keine Chance\ngegen [CS:N]Darkrai[CR]!", italian="Chi vogliamo prendere in giro?\nNon abbiamo speranze di farcela contro [CS:N]Darkrai[CR]\nin ogni caso!", spanish="¿A quién queremos engañar? ¡No\npodemos derrotar a [CS:N]Darkrai[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Who are we kidding? We don't\nstand a chance against [CS:N]Darkrai[CR] anyway!", french="Ne nous faisons pas d'illusions!\nDe toute façon, on n'a aucune chance contre\n[CS:N]Darkrai[CR]!", german="Wem wollen wir etwas\nvormachen? Wir haben sowieso keine Chance\ngegen [CS:N]Darkrai[CR]!", italian="Chi vogliamo prendere in giro?\nNon abbiamo speranze di farcela contro [CS:N]Darkrai[CR]\nin ogni caso!", spanish="¿A quién queremos engañar? ¡No\npodemos derrotar a [CS:N]Darkrai[CR]!"})
  else
  SkySceneKit.say({english="Who are we kidding? We don't\nstand a chance against [CS:N]Darkrai[CR] anyway!", french="Ne nous faisons pas d'illusions!\nDe toute façon, on n'a aucune chance contre\n[CS:N]Darkrai[CR]!", german="Wem wollen wir etwas\nvormachen? Wir haben sowieso keine Chance\ngegen [CS:N]Darkrai[CR]!", italian="Chi vogliamo prendere in giro?\nNon abbiamo speranze di farcela contro [CS:N]Darkrai[CR]\nin ogni caso!", spanish="¿A quién queremos engañar? ¡No\npodemos derrotar a [CS:N]Darkrai[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's pointless to resist.", french=" Inutile de résister.", german=" Jeder Widerstand ist zwecklos.", italian=" Non ha senso opporre resistenza.", spanish=" Es inútil resistirse."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It's pointless to resist.", french=" Inutile de résister.", german=" Jeder Widerstand ist zwecklos.", italian=" Non ha senso opporre resistenza.", spanish=" Es inútil resistirse."})
  else
  SkySceneKit.say({english=" It's pointless to resist.", french=" Inutile de résister.", german=" Jeder Widerstand ist zwecklos.", italian=" Non ha senso opporre resistenza.", spanish=" Es inútil resistirse."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Joining [CS:N]Darkrai[CR]...", french=" Joignons-nous à [CS:N]Darkrai[CR]...", german=" Gemeinsame Sache mit [CS:N]Darkrai[CR]...", italian=" Passare dalla parte di [CS:N]Darkrai[CR]...", spanish=" Unirse a [CS:N]Darkrai[CR]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Joining [CS:N]Darkrai[CR]...", french=" Joignons-nous à [CS:N]Darkrai[CR]...", german=" Gemeinsame Sache mit [CS:N]Darkrai[CR]...", italian=" Passare dalla parte di [CS:N]Darkrai[CR]...", spanish=" Unirse a [CS:N]Darkrai[CR]..."})
  else
  SkySceneKit.say({english=" Joining [CS:N]Darkrai[CR]...", french=" Joignons-nous à [CS:N]Darkrai[CR]...", german=" Gemeinsame Sache mit [CS:N]Darkrai[CR]...", italian=" Passare dalla parte di [CS:N]Darkrai[CR]...", spanish=" Unirse a [CS:N]Darkrai[CR]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It may be the best thing to do.", french="C'est peut-être la meilleure\nchose à faire.", german="Es ist vielleicht das Beste, was\nman tun kann.", italian="Penso che potrebbe essere la\ncosa migliore.", spanish=" Podría ser la mejor opción."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It may be the best thing to do.", french="C'est peut-être la meilleure\nchose à faire.", german="Es ist vielleicht das Beste, was\nman tun kann.", italian="Penso che potrebbe essere la\ncosa migliore.", spanish=" Podría ser la mejor opción."})
  else
  SkySceneKit.say({english=" It may be the best thing to do.", french="C'est peut-être la meilleure\nchose à faire.", german="Es ist vielleicht das Beste, was\nman tun kann.", italian="Penso che potrebbe essere la\ncosa migliore.", spanish=" Podría ser la mejor opción."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([partner]![K] Wh-why?!)", french="([partner]![K] Mais... mais pourquoi?!)", german="([partner]![K] W-warum?!?)", italian="([partner]![K] P-Perché?!)", spanish="(¡[partner]! ¿Qué?[K] ¡¿Por qué?!)"})
  else
  SkySceneKit.say({english="([partner]![K] Wh-why?!)", french="([partner]![K] Mais... mais pourquoi?!)", german="([partner]![K] W-warum?!?)", italian="([partner]![K] P-Perché?!)", spanish="(¡[partner]! ¿Qué?[K] ¡¿Por qué?!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(partner, 252, 148, false, 1)
  GROUND:EntTurn(npc_npc_kureseria, Direction.UpLeft)
  GROUND:EntTurn(hero, Direction.UpLeft)
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_daakurai, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" Mwahaha...", french=" Mwa ha ha...", german=" Muahaha...", italian=" Muahaha...", spanish=" Ja, ja, ja..."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="You chose wisely, [partner].\nVery practical of you.", french="Sage décision, [partner].\nLe pragmatisme, il n'y a que ça de vrai.", german="Eine weise Entscheidung,\n[partner]. Sehr praktisch gedacht.", italian="Hai fatto la scelta giusta,\n[partner]. Molto saggio da parte tua.", spanish="Has escogido sabiamente,\n[partner]. Muy práctico por tu parte."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_daakurai, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="Now, [hero].[K] What will\nyou do?", french="Et toi, [hero].[K] Tu as\nchoisi ton camp?", german="[hero]![K] Was wirst du\njetzt tun?", italian="E tu, [hero].[K] Cosa vuoi\nfare?", spanish="Decide, [hero].[K] ¿Qué vas\na hacer?"})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" When you are one of us...", french=" Quand tu nous auras rejoints...", german="Wenn wir drei uns\nzusammentun...", italian=" Se ti unisci a noi...", spanish=" Si te unes a nosotros..."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="Our first order of business will\nbe [CS:N]Cresselia[CR] there.", french="Notre priorité sera de régler\nson compte à cette chère [CS:N]Cresselia[CR].", german="Dann werden wir uns als Erstes\nmit [CS:N]Cresselia[CR] beschäftigen.", italian="... la prima cosa da fare sarà\noccuparsi di [CS:N]Cresselia[CR].", spanish="[CS:N]Cresselia[CR] será nuestro primer\nobjetivo."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="The three of us shall get rid of\nher together.", french="Nous nous débarrasserons d'elle\nensemble, tous les trois.", german="Wir drei werden sie zusammen\nlos.", italian="Noi tre ce ne sbarazzeremo\ninsieme.", spanish=" Juntos acabaremos con ella."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  GROUND:EntTurn(npc_npc_kureseria, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" Wh-what did you say?!", french=" Quoi?! Qu'est-ce que tu dis?", german=" W-was hast du gesagt?!?", italian=" C-Cosa hai detto?!", spanish=" ¿Qué has dicho?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="Now, [hero]. Come, join\nus here.", french="Allez, [hero]. Viens à\nnous, viens nous rejoindre.", german="Jetzt, [hero]. Komm zu\nuns.", italian="Adesso, [hero]. Vieni,\nunisciti a noi.", spanish="Anímate, [hero]. Únete a\nnosotros."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GROUND:EntTurn(npc_npc_kureseria, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" Don't go...[K] [hero]!", french=" N'y va pas...[K] [hero]!", german=" Geh nicht...[K] [hero]!", italian=" Non andare...[K] [hero]!", spanish=" No lo hagas...[K] ¡[hero]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.DownRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Please, come here, [hero].", french=" Viens, [hero], je t'en prie.", german=" Komm zu uns, [hero].", italian="Per favore, vieni qui,\n[hero].", spanish=" Ven aquí, [hero]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Please, come here, [hero].", french=" Viens, [hero], je t'en prie.", german=" Komm zu uns, [hero].", italian="Per favore, vieni qui,\n[hero].", spanish=" Ven aquí, [hero]."})
  else
  SkySceneKit.say({english=" Please, come here, [hero].", french=" Viens, [hero], je t'en prie.", german=" Komm zu uns, [hero].", italian="Per favore, vieni qui,\n[hero].", spanish=" Ven aquí, [hero]."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "shock", 1) end)
  GROUND:EntTurn(npc_npc_kureseria, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" [partner]!", french=" [partner]!", german=" [partner]!", italian=" [partner]!", spanish=" ¡[partner]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="If you won't join us,\n[hero]...", french="Si tu ne te joins pas à nous,\n[hero]...", german="Wenn du nicht zu uns gehören\nwillst, [hero]...", italian="Se non passi dalla nostra\nparte, [hero]...", spanish="Si no te unes a nosotros,\n[hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="If you won't join us,\n[hero]...", french="Si tu ne te joins pas à nous,\n[hero]...", german="Wenn du nicht zu uns gehören\nwillst, [hero]...", italian="Se non passi dalla nostra\nparte, [hero]...", spanish="Si no te unes a nosotros,\n[hero]..."})
  else
  SkySceneKit.say({english="If you won't join us,\n[hero]...", french="Si tu ne te joins pas à nous,\n[hero]...", german="Wenn du nicht zu uns gehören\nwillst, [hero]...", italian="Se non passi dalla nostra\nparte, [hero]...", spanish="Si no te unes a nosotros,\n[hero]..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Darkrai[CR] surely won't want just\nme... He'll get rid of me...", french="... [CS:N]Darkrai[CR] ne voudra sûrement\npas de moi seul... Il se débarrassera de moi...", german="Dann wird [CS:N]Darkrai[CR] sich nicht mit\nmir begnügen. Es wird mich beseitigen...", italian="[CS:N]Darkrai[CR] di sicuro non vuole\nsolo me... Mi farà fuori...", spanish="[CS:N]Darkrai[CR] no me querrá a su\nlado. Se deshará de mí."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="[CS:N]Darkrai[CR] surely won't want just\nme... He'll get rid of me...", french="... [CS:N]Darkrai[CR] ne voudra sûrement\npas de moi seul... Il se débarrassera de moi...", german="Dann wird [CS:N]Darkrai[CR] sich nicht mit\nmir begnügen. Es wird mich beseitigen...", italian="[CS:N]Darkrai[CR] di sicuro non vuole\nsolo me... Mi farà fuori...", spanish="[CS:N]Darkrai[CR] no me querrá a su\nlado. Se deshará de mí."})
  else
  SkySceneKit.say({english="[CS:N]Darkrai[CR] surely won't want just\nme... He'll get rid of me...", french="... [CS:N]Darkrai[CR] ne voudra sûrement\npas de moi seule... Il se débarrassera de moi...", german="Dann wird [CS:N]Darkrai[CR] sich nicht mit\nmir begnügen. Es wird mich beseitigen...", italian="[CS:N]Darkrai[CR] di sicuro non vuole\nsolo me... Mi farà fuori...", spanish="[CS:N]Darkrai[CR] no me querrá a su\nlado. Se deshará de mí."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([partner]...)", french="([partner]...)", german="([partner]...)", italian="([partner]...)", spanish="([partner]...)"})
  else
  SkySceneKit.say({english="([partner]...)", french="([partner]...)", german="([partner]...)", italian="([partner]...)", spanish="([partner]...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(45)
  pcall(function() SOUND:FadeOutBGM(120) end)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-32), false, 1) end
  GROUND:MoveToPosition(hero, 276, 172, false, 1)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "shock", 1) end)
  GROUND:EntTurn(npc_npc_kureseria, Direction.Up)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  GAME:WaitFrames(2) -- join WaitBgm
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" Mwahaha...", french=" Mwa ha ha...", german=" Muahaha...", italian=" Muahaha...", spanish=" Ja, ja, ja..."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" Your choice, [hero]?", french=" Ta décision, [hero]?", german=" Deine Wahl, [hero]?", italian="Qual è la tua decisione,\n[hero]?", spanish=" ¿Qué decides, [hero]?"})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" Will you join us?", french=" Vas-tu te joindre à nous?", german=" Wirst du dich uns anschließen?", italian=" Ti unirai a noi?", spanish=" ¿Te unirás a nosotros?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  else
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(-2, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="The world of darkness is going\nto be wonderful, [hero]...", french="Un merveilleux monde plongé\ndans l'ombre éternelle, et qui n'attend que toi,\n[hero]...", german="Die Welt der Dunkelheit wird\nwundervoll sein, [hero].", italian="Il mondo dell'oscurità sarà\nbellissimo, [hero]...", spanish="El mundo de la oscuridad será\nmaravilloso, [hero]..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="The world of darkness is going\nto be wonderful, [hero]...", french="Un merveilleux monde plongé\ndans l'ombre éternelle, et qui n'attend que toi,\n[hero]...", german="Die Welt der Dunkelheit wird\nwundervoll sein, [hero].", italian="Il mondo dell'oscurità sarà\nbellissimo, [hero]...", spanish="El mundo de la oscuridad será\nmaravilloso, [hero]..."})
  else
  SkySceneKit.say({english="The world of darkness is going\nto be wonderful, [hero]...", french="Un merveilleux monde plongé\ndans l'ombre éternelle, et qui n'attend que toi,\n[hero]...", german="Die Welt der Dunkelheit wird\nwundervoll sein, [hero].", italian="Il mondo dell'oscurità sarà\nbellissimo, [hero]...", spanish="El mundo de la oscuridad será\nmaravilloso, [hero]..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="You see?[K] Your trusted partner\nhas seen the truth.", french="Tu vois?[K] Ton acolyte a vu\nla vérité.", german="Siehst du?[K] Dein vertrauter\nPartner hat die Wahrheit erkannt.", italian="Vedi?[K] Questo Pokémon, di cui\ntu ti fidi tanto, ha capito come stanno\nle cose!", spanish="¿Lo ves?[K] Tu acompañante ha\nsabido escoger."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="Come. Will you not rule the\nworld with us?", french="Viens. Joins-toi à nous et\ndominons le monde!", german="Komm. Willst du nicht die Welt\nmit uns beherrschen?", italian="Deciditi! Vuoi dominare il mondo\ncon noi?!", spanish="Venga. ¿No quieres gobernar el\nmundo con nosotros?"})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="And you shall...[K]reign as lord in\nthe world of darkness.", french="Et grâce à moi...[K] tu régneras\nsur le monde des ombres.", german="Du wirst[K] als Herrscher über die\nWelt der Dunkelheit gebieten.", italian="Tu...[K] regnerai sul mondo\ndell'oscurità.", spanish="Reinarás...[K] en el mundo de la\noscuridad."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  else
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="Now, [hero].[K] Consider\nyour answer carefully.", french="Allons, [hero].[K] Réfléchis\nbien avant de répondre.", german="Also, [hero].[K] Bedenke\ndeine Antwort sorgfältig.", italian="Attenzione, [hero].[K]\nScegli bene la tua risposta.", spanish="Bueno, [hero].[K] Medita bien\ntu respuesta."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" Join me and [partner]...", french="Rejoins-nous, moi et\n[partner]...", german=" Komm zu mir und [partner]...", italian=" Unisciti a me e [partner].", spanish=" Únete a mí y a [partner]..."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" We'll rule the world together!", french="Nous régnerons en maîtres\nincontestés sur le monde!", german="Wir werden zusammen die Welt\nbeherrschen!", italian=" Regneremo insieme sul mondo!", spanish=" ¡Juntos dominaremos el mundo!"})
  do local __choice = SkySceneKit.ask({{english="..................", french="..................", german="..................", italian="..................", spanish="..."}, {english="I refuse!", french="Hors de question!", german="Ich weigere mich!", italian="Mi rifiuto!", spanish="¡Me niego!"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Do that...?[K] I refuse!)", french="(Que je fasse ça...?[K] Jamais!)", german="(Nein![K] Ich weigere mich!)", italian="(No...[K] Mi rifiuto!)", spanish="(No puedo...[K] ¡Me niego!)"})
  else
  SkySceneKit.say({english="(Do that...?[K] I refuse!)", french="(Que je fasse ça...?[K] Jamais!)", german="(Nein![K] Ich weigere mich!)", italian="(No...[K] Mi rifiuto!)", spanish="(No puedo...[K] ¡Me niego!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(This is all...[K] This is all...)", french="(Tout ça n'est...[K] tout ça n'est...)", german="(Das ist alles...[K] Das ist alles...)", italian="(Questo è...[K] È tutto...)", spanish="(Esto es...[K] Esto es...)"})
  else
  SkySceneKit.say({english="(This is all...[K] This is all...)", french="(Tout ça n'est...[K] tout ça n'est...)", german="(Das ist alles...[K] Das ist alles...)", italian="(Questo è...[K] È tutto...)", spanish="(Esto es...[K] Esto es...)"})
  end
  -- message_Close
  pcall(function() SOUND:StopBGM() end)
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:WaitFrames(15)
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  else -- default/annulation
  -- @label_0 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  else
  SkySceneKit.say({english="(..................)", french="(..................)", german="(..................)", italian="(..................)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...My...)", french="(... Ma...)", german="(Meine...)", italian="(La mia...)", spanish="(Mi...)"})
  else
  SkySceneKit.say({english="(...My...)", french="(... Ma...)", german="(Meine...)", italian="(La mia...)", spanish="(Mi...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...My answer is...)", french="(... Ma réponse est...)", german="(Meine Antwort ist...)", italian="(La mia risposta è...)", spanish="(Mi respuesta es...)"})
  else
  SkySceneKit.say({english="(...My answer is...)", french="(... Ma réponse est...)", german="(Meine Antwort ist...)", italian="(La mia risposta è...)", spanish="(Mi respuesta es...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:WaitFrames(15)
  do local __sw = ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) -- switch($PARTNER_TALK_KIND) [GameVar PARTNER_TALK_KIND (genre partenaire)]
  if __sw == 1 then
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]Don't, [hero]!", french="[CN]Non, [hero]!", german="[CN]Tu es nicht, [hero]!", italian="[CN]Non farlo, [hero]!", spanish="[CN]¡No, [hero]!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]Don't be fooled!", french="[CN]Ne le laisse pas te berner!", german="[CN]Lass dich nicht reinlegen!", italian="[CN]Non farti ingannare!", spanish="[CN]¡No te dejes engañar!"})
  -- @label_5 [étiquette de flux ExplorerScript]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="......!", french="......!", german="......", italian="......!", spanish="¿Eh?"})
  else
  SkySceneKit.say({english="......!", french="......!", german="......", italian="......!", spanish="¿Eh?"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="Th-that voice just now...[K] [partner]?!", french="Cette voix, à l'instant...[K] [partner]?!", german="D-diese Stimme gerade...[K] [partner]?", italian="Q-Questa voce...[K] [partner]?!", spanish="Esa voz...[K] ¿[partner]?"})
  else
  SkySceneKit.say({english="Th-that voice just now...[K] [partner]?!", french="Cette voix, à l'instant...[K] [partner]?!", german="D-diese Stimme gerade...[K] [partner]?", italian="Q-Questa voce...[K] [partner]?!", spanish="Esa voz...[K] ¿[partner]?"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="Th-that's it![K] This is all...[K] This is all...", french="Oui, c'est moi![K] Tout ça n'est que...[K] tout ça\nn'est que...", german="D-das ist es![K] Das ist alles...[K] Das ist alles...", italian="Ci sono![K] Q-Questo è...[K] È tutto...", spanish="¡Ya está![K] Se acabó...[K] Se acabó..."})
  else
  SkySceneKit.say({english="Th-that's it![K] This is all...[K] This is all...", french="Oui, c'est moi![K] Tout ça n'est que...[K] tout ça\nn'est que...", german="D-das ist es![K] Das ist alles...[K] Das ist alles...", italian="Ci sono![K] Q-Questo è...[K] È tutto...", spanish="¡Ya está![K] Se acabó...[K] Se acabó..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- @label_6 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyVars or {}).HERO_TALK_KIND or 0) -- switch($HERO_TALK_KIND) [GameVar HERO_TALK_KIND (genre héros)]
  if __sw == 4 then
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CN]This is all...[K]\n[CN]a nightmare!", french="[CN]Tout ça n'est...[K]\n[CN]qu'un cauchemar!", german="[CN]Das ist alles...[K]\n[CN]ein Albtraum!", italian="[CN]È tutto...[K]\n[CN]un incubo!", spanish="[CN]Esto es...[K]\n[CN]¡Una pesadilla!"})
  -- @label_9 [étiquette de flux ExplorerScript]
  -- message_Close
  -- GAP: se_Play(8198) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 30) -- screen_WhiteOut
  GAME:WaitFrames(60)
  GROUND:TeleportTo(npc_npc_daakurai, 276, 164, Direction.Down)
  GROUND:TeleportTo(npc_npc_kureseria, 292, 220, Direction.Down)
  GROUND:TeleportTo(partner, 260, 220, Direction.Down)
  GROUND:EntTurn(npc_npc_daakurai, Direction.Down)
  GROUND:EntTurn(npc_npc_kureseria, Direction.Up)
  GROUND:EntTurn(partner, Direction.Up)
  GAME:FadeIn(0) -- screen_FlushIn
  GAME:FadeIn(15)
  GAME:WaitFrames(30)
  -- GAP: se_Play(5126) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(13) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_daakurai, "shock", 1) end)
  -- SetAnimation(11) [anim idle native]
  do local p=npc_npc_daakurai.Position; GROUND:MoveToPosition(npc_npc_daakurai, p.X+(0), p.Y+(-16), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(43) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" Gaaaah!", french=" Aaah!", german=" Gaaaah!", italian=" Aaaaah!", spanish=" ¡Aaaah!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh, [hero]!", french=" Oh, [hero]!", german=" Oh, [hero]!", italian=" Oh, [hero]!", spanish=" ¡[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh, [hero]!", french=" Oh, [hero]!", german=" Oh, [hero]!", italian=" Oh, [hero]!", spanish=" ¡[hero]!"})
  else
  SkySceneKit.say({english=" Oh, [hero]!", french=" Oh, [hero]!", german=" Oh, [hero]!", italian=" Oh, [hero]!", spanish=" ¡[hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english=" Oh, [hero]!", french=" Oh, [hero]!", german=" Oh, [hero]!", italian=" Oh, [hero]!", spanish=" ¡[hero]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(2) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_daakurai, "shock", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" Y-you!", french=" Toi!", german=" D-du!", italian=" T-Tu!", spanish=" ¡Tú!"})
  -- message_Close
  -- SetAnimation(12) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(16), 6, false) end) -- MovePositionOffset performer/caméra
  GROUND:EntTurn(hero, Direction.Left)
  -- SetAnimation(68) [anim idle native]
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(32), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "shock", 1) end)
  -- SetAnimation(5) [anim idle native]
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(4), false, 2) end -- SlidePositionOffset
  do local p=npc_npc_kureseria.Position; GROUND:MoveToPosition(npc_npc_kureseria, p.X+(0), p.Y+(4), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  do local p=npc_npc_daakurai.Position; GROUND:MoveToPosition(npc_npc_daakurai, p.X+(0), p.Y+(16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I was right!)", french="(J'avais raison!)", german="(Ich hatte recht!)", italian="(Avevo ragione!)", spanish="(¡Tenía razón!)"})
  else
  SkySceneKit.say({english="(I was right!)", french="(J'avais raison!)", german="(Ich hatte recht!)", italian="(Avevo ragione!)", spanish="(¡Tenía razón!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(63) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I was being deceived!)", french="(C'était un leurre!)", german="(Ich wurde getäuscht!)", italian="(Mi stava ingannando!)", spanish="(¡Me estaba engañando!)"})
  else
  SkySceneKit.say({english="(I was being deceived!)", french="(C'était un leurre!)", german="(Ich wurde getäuscht!)", italian="(Mi stava ingannando!)", spanish="(¡Me estaba engañando!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([CS:N]Darkrai[CR] was showing me an illusion!)", french="(Juste une illusion créée de toutes pièces par\n[CS:N]Darkrai[CR]!)", german="([CS:N]Darkrai[CR] hat mir eine Illusion vorgehalten!)", italian="([CS:N]Darkrai[CR] mi stava facendo vedere un'illusione!)", spanish="(¡[CS:N]Darkrai[CR] me estaba mostrando una\nilusión!)"})
  else
  SkySceneKit.say({english="([CS:N]Darkrai[CR] was showing me an illusion!)", french="(Juste une illusion créée de toutes pièces par\n[CS:N]Darkrai[CR]!)", german="([CS:N]Darkrai[CR] hat mir eine Illusion vorgehalten!)", italian="([CS:N]Darkrai[CR] mi stava facendo vedere un'illusione!)", spanish="(¡[CS:N]Darkrai[CR] me estaba mostrando una\nilusión!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That was close!)", french="(Il était moins une!)", german="(Das war knapp!)", italian="(C'è mancato poco!)", spanish="(¡Por poco!)"})
  else
  SkySceneKit.say({english="(That was close!)", french="(Il était moins une!)", german="(Das war knapp!)", italian="(C'è mancato poco!)", spanish="(¡Por poco!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_DOWN_A_DARK_PATH non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="Blast it! I was on the verge of\nsuccess!", french="Malédiction! J'étais si près\ndu but!", german="Verflixt! Ich war so nah am\nErfolg!", italian="Maledizione! Stavo per\nfarcela!", spanish="¡Maldición! ¡He estado a punto\nde lograrlo!"})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="Is that your answer,\n[hero]?!", french="Est-ce là ton dernier mot,\n[hero]?!", german="Ist das deine Antwort,\n[hero]?!?", italian="È la tua risposta,\n[hero]?!", spanish="¿Es esa tu última palabra,\n[hero]?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(0, -2) [neutre/état moteur]
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Of course!)", french="(Et comment!)", german="(Selbstverständlich!)", italian="(Certo!)", spanish="(¡Por supuesto!)"})
  else
  SkySceneKit.say({english="(Of course!)", french="(Et comment!)", german="(Selbstverständlich!)", italian="(Certo!)", spanish="(¡Por supuesto!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([partner] would never consider even\nsaying something like that!)", french="(Ça ne viendrait même pas à l'esprit\nde [partner] de dire des choses pareilles!)", german="([partner] würde unter keinen Umständen\nso etwas sagen!)", italian="([partner] non direbbe mai una cosa\ndel genere!)", spanish="(¡[partner] nunca haría algo así!)"})
  else
  SkySceneKit.say({english="([partner] would never consider even\nsaying something like that!)", french="(Ça ne viendrait même pas à l'esprit\nde [partner] de dire des choses pareilles!)", german="([partner] würde unter keinen Umständen\nso etwas sagen!)", italian="([partner] non direbbe mai una cosa\ndel genere!)", spanish="(¡[partner] nunca haría algo así!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Join with [CS:N]Darkrai[CR]?[K] Not on my life!)", french="(M'associer à [CS:N]Darkrai[CR]?[K] Jamais de la vie!)", german="(Mich mit [CS:N]Darkrai[CR] verbünden?[K] Niemals!)", italian="(Unirmi a [CS:N]Darkrai[CR]?[K] Mai!)", spanish="(¿Unirme a [CS:N]Darkrai[CR]?[K] ¡Eso nunca!)"})
  else
  SkySceneKit.say({english="(Join with [CS:N]Darkrai[CR]?[K] Not on my life!)", french="(M'associer à [CS:N]Darkrai[CR]?[K] Jamais de la vie!)", german="(Mich mit [CS:N]Darkrai[CR] verbünden?[K] Niemals!)", italian="(Unirmi a [CS:N]Darkrai[CR]?[K] Mai!)", spanish="(¿Unirme a [CS:N]Darkrai[CR]?[K] ¡Eso nunca!)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(A world of darkness...[K] I won't let it happen!)", french="(Un monde plongé dans l'ombre...[K] Je m'y\nopposerai de toutes mes forces!)", german="(Eine Welt der Dunkelheit...[K] Ich werde das\nnicht zulassen!)", italian="(Un mondo di oscurità...[K]\nNon lascerò che accada!)", spanish="(Un mundo de oscuridad...[K] ¡Nunca permitiré\nque eso ocurra!)"})
  else
  SkySceneKit.say({english="(A world of darkness...[K] I won't let it happen!)", french="(Un monde plongé dans l'ombre...[K] Je m'y\nopposerai de toutes mes forces!)", german="(Eine Welt der Dunkelheit...[K] Ich werde das\nnicht zulassen!)", italian="(Un mondo di oscurità...[K]\nNon lascerò che accada!)", spanish="(Un mundo de oscuridad...[K] ¡Nunca permitiré\nque eso ocurra!)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="Humph...[K] So be it.[K] You've made\nthe wrong choice.", french=" Pfff...[K] Soit.[K] Mauvaise réponse.", german="Hmpf...[K] So sei es.[K] Du hast die\nfalsche Wahl getroffen.", italian="Bah...[K] Come vuoi.[K] Hai fatto\nla scelta sbagliata.", spanish="En fin...[K] Así sea.[K] Has tomado la\ndecisión equivocada."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="There's nothing left to say.[K]\nI will be rid of you now.", french="Il n'y a rien à ajouter.[K]\nJe m'en vais t'éliminer.", german="Es gibt nichts mehr zu sagen.[K]\nIch werde euch jetzt beseitigen.", italian="Non c'è altro da aggiungere.[K]\nAdesso mi sbarazzerò di voi.", spanish="No hay nada más que hablar.[K]\nTerminaré con esto aquí y ahora."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5133) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(false, 15)
  GAME:WaitFrames(15)
  -- supervision_Acting(1) [neutre/état moteur]
  GAME:FadeIn(15)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "shock", 1) end)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(12)
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(4)
  -- ExecuteCommon(CORO_LOOK_AROUND_DOWN_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(7)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whoa![K] We're surrounded!", french=" Ouah![K] Ils sont trop nombreux!", german=" Hooaah![K] Wir sind umzingelt!", italian=" Ehi![K] Siamo circondati!", spanish=" ¡Aah![K] ¡Nos han rodeado!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waah![K] We're surrounded!", french=" Ouah![K] Ils sont trop nombreux!", german=" Hooaah![K] Wir sind umzingelt!", italian=" Aaah![K] Siamo circondati!", spanish=" ¡Aah![K] ¡Nos han rodeado!"})
  else
  SkySceneKit.say({english=" Waah![K] We're surrounded!", french=" Ouah![K] Ils sont trop nombreux!", german=" Hooaah![K] Wir sind umzingelt!", italian=" Aaah![K] I nemici ci circondano!", spanish=" ¡Aah![K] ¡Nos han rodeado!"})
  end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_kureseria, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_kureseria) end)
  SkySceneKit.say({english="I knew it.[K] I figured that you\nwould do something like this!", french="Je le savais.[K] Je me doutais\nque tu nous préparais un mauvais coup!", german="Ich wusste es.[K] Ich hab mir\nschon gedacht, dass du so etwas tun würdest!", italian="Lo sapevo.[K] Immaginavo che\navresti fatto qualcosa del genere!", spanish="Lo sabía.[K] ¡Sabía que harías\nalgo así!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" Humph. Say what you will.", french="Pfff! Parle tant que tu le peux\nencore.", german=" Hmpf. Sag doch, was du willst.", italian=" Uhm. Pensa quello che vuoi.", spanish=" Puedes decir lo que quieras."})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="This is where I will finally be\nrid of you meddlers.", french="Je vais enfin me débarrasser\ndes importuns que vous êtes!", german="An diesem Punkt werde ich euch\nEinmischer endlich beseitigen.", italian="Finalmente oggi mi\nsbarazzerò di voi ficcanaso.", spanish=" Aquí se acaba vuestra aventura."})
  -- message_Close
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="I will seize control of the\ndarkened world...", french="Je prendrai le contrôle\ndu monde...", german="Ich werde die Kontrolle über\ndie verdunkelte Welt an mich reißen...", italian="Prenderò il controllo del\nmondo dell'oscurità...", spanish=" Tomaré el control del mundo..."})
  -- message_Close
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" as its king.", french=" ... et j'en serai le souverain.", german=" Als ihr König!", italian=" Ne diventerò il sovrano.", spanish=" Y seré su rey."})
  -- message_Close
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english=" This is it![K] Attack!", french=" A l'attaque![K] Maintenant!", german=" Jetzt ist der Zeitpunkt![K] Angriff!", italian=" Basta parlare![K] All'attacco!", spanish=" ¡Se acabó![K] ¡Atacad!"})
  -- message_Close
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:StopBGM() end)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(10)
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  GAME:WaitFrames(2) -- join WaitSe
  -- GAP: se_Play(5136) — id SE NDS sans portage PMDO identifié
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  elseif true then -- default
  -- @label_8 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[CN]This is all...[K]\n[CN]a nightmare!", french="[CN]Tout ça n'est...[K]\n[CN]qu'un cauchemar!", german="[CN]Das ist alles...[K]\n[CN]ein Albtraum!", italian="[CN]È tutto...[K]\n[CN]un incubo!", spanish="[CN]Esto es...[K]\n[CN]¡Una pesadilla!"})
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __sw == 2 then
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[CN]Don't, [hero]!", french="[CN]Non, [hero]!", german="[CN]Tu es nicht, [hero]!", italian="[CN]Non farlo, [hero]!", spanish="[CN]¡No, [hero]!"})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[CN]Don't be fooled!", french="[CN]Ne le laisse pas te berner!", german="[CN]Lass dich nicht reinlegen!", italian="[CN]Non farti ingannare!", spanish="[CN]¡No te dejes engañar!"})
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_4 [étiquette de flux ExplorerScript]
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[CN]Don't, [hero]!", french="[CN]Non, [hero]!", german="[CN]Tu es nicht, [hero]!", italian="[CN]Non farlo, [hero]!", spanish="[CN]¡No, [hero]!"})
  pcall(function() UI:SetSpeaker(npc_npc_daakurai) end)
  SkySceneKit.say({english="[CN]Don't be fooled!", french="[CN]Ne le laisse pas te berner!", german="[CN]Lass dich nicht reinlegen!", italian="[CN]Non farti ingannare!", spanish="[CN]¡No te dejes engañar!"})
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  SkySceneKit.cleanup_npcs()
end
