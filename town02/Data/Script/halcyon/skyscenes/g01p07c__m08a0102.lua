-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07C/m08a0102.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P07C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Goodnight.ogg", true) end)
  GAME:WaitFrames(30)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Tomorrow they're finally going\nto announce the members of the expedition.", french="Demain ils vont enfin annoncer\nqui fera partie de l'expédition.", german="Morgen werden endlich die\nMitglieder der Expedition bekanntgegeben.", italian="Finalmente domani annunceranno\ni nomi dei Pokémon che parteciperanno\nalla spedizione.", spanish="Mañana por fin van a anunciar\nquiénes irán a la expedición."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Tomorrow they're finally going\nto announce the members of the expedition.", french="Demain ils vont enfin annoncer\nqui fera partie de l'expédition.", german="Morgen werden endlich die\nMitglieder der Expedition bekanntgegeben.", italian="Finalmente domani annunceranno\ni nomi dei Pokémon che parteciperanno alla\nspedizione.", spanish="Al fin se va a anunciar mañana\nquiénes podrán ir a la expedición."})
  else
  SkySceneKit.say({english="Tomorrow they're finally going\nto announce the members of the expedition.", french="Demain ils vont enfin annoncer\nqui fera partie de l'expédition.", german="Morgen werden endlich die\nMitglieder der Expedition bekanntgegeben.", italian="Finalmente domani annunceranno\ni nomi dei Pokémon che parteciperanno alla\nspedizione.", spanish="Al fin, anunciarán mañana\nquiénes podrán ir a la expedición."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I'm kind of excited.", french=" Je suis un peu nerveux.", german=" Ich bin ziemlich gespannt.", italian=" Sono emozionato.", spanish=" Estoy algo nervioso."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I'm feeling sort of nervous.", french=" Je suis un peu nerveux.", german=" Ich bin irgendwie nervös.", italian=" Sono un po' nervoso.", spanish=" Estoy un poco nervioso."})
  else
  SkySceneKit.say({english=" It's making me sort of nervous.", french=" Je suis un peu nerveuse.", german="Das macht mich irgendwie\nnervös.", italian=" Non sto più nella pelle.", spanish=" Estoy algo nerviosa."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yeah, I know [CS:N]Chatot[CR] said we\ndon't have much of a chance.", french="Ouais, je sais que [CS:N]Pijako[CR] nous a\ndit que nos chances d'en faire partie étaient\nfaibles.", german="Ja, ich weiß, [CS:N]Plaudagei[CR] sagte,\ndass wir fast keine Chance haben.", italian="È vero, [CS:N]Chatot[CR] ha detto\nche non abbiamo molte possibilità.", spanish="Sí, ya sé que [CS:N]Chatot[CR] nos dijo\nque no teníamos posibilidades."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yes, I know [CS:N]Chatot[CR] said we\nshouldn't get our hopes up.", french="Ouais, je sais que [CS:N]Pijako[CR] nous a\ndit que nos chances d'en faire partie étaient\nfaibles.", german="Ja, ich weiß, [CS:N]Plaudagei[CR] sagte,\nwir sollen uns keine Hoffnungen machen.", italian="È vero, [CS:N]Chatot[CR] ha detto\nche non abbiamo molte possibilità.", spanish="Sí, ya sé que [CS:N]Chatot[CR] dijo que\nno nos hiciéramos ilusiones."})
  else
  SkySceneKit.say({english="Oh, I know [CS:N]Chatot[CR] said we\nshouldn't be too hopeful.", french="Ouais, je sais que [CS:N]Pijako[CR] nous a\ndit que nos chances d'en faire partie étaient\nfaibles.", german="Ja, ich weiß, [CS:N]Plaudagei[CR] sagte,\nwir sollten nichts erwarten.", italian="È vero, [CS:N]Chatot[CR] ha detto\nche non abbiamo molte possibilità.", spanish="Sí, ya sé que [CS:N]Chatot[CR] dijo que\nno nos hiciéramos ilusiones."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="After all, we didn't bring back\nany of those Perfect Apples that [CS:N]Wigglytuff[CR]\nloves so much.", french="C'est vrai, quoi! Nous n'avons\npas rapporté une seule des Pommes Parfaites\nque [CS:N]Grodoudou[CR] aime tant.", german="Schließlich haben wir [CS:N]Knuddeluff[CR]\nkeinen der Perfekten Äpfel gebracht, die er\nso liebt.", italian="In fondo non abbiamo trovato\nneanche una di quelle Mele Perfette di cui\n[CS:N]Wigglytuff[CR] è così ghiotto.", spanish="Después de todo, no conseguimos\ntraerle a [CS:N]Wigglytuff[CR] ninguna de esas\nManzanas Perfectas que tanto le gustan."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="After all, we didn't bring back\nany of those Perfect Apples that [CS:N]Wigglytuff[CR]\nloves so much.", french="C'est vrai, quoi! Nous n'avons\npas rapporté une seule des Pommes Parfaites\nque [CS:N]Grodoudou[CR] aime tant.", german="Schließlich haben wir [CS:N]Knuddeluff[CR]\nkeinen der Perfekten Äpfel gebracht, die er\nso liebt.", italian="In fondo non abbiamo trovato\nneanche una di quelle Mele Perfette di cui\n[CS:N]Wigglytuff[CR] è così ghiotto.", spanish="Después de todo, no conseguimos\ntraerle a [CS:N]Wigglytuff[CR] ninguna de esas\nManzanas Perfectas que tanto le gustan."})
  else
  SkySceneKit.say({english="After all, we didn't bring back\nany of those Perfect Apples that [CS:N]Wigglytuff[CR]\nloves so much.", french="C'est vrai, quoi! Nous n'avons\npas rapporté une seule des Pommes Parfaites\nque [CS:N]Grodoudou[CR] aime tant.", german="Schließlich haben wir [CS:N]Knuddeluff[CR]\nkeinen der Perfekten Äpfel gebracht, die er\nso liebt.", italian="In fondo non abbiamo trovato\nneanche una di quelle Mele Perfette di cui\n[CS:N]Wigglytuff[CR] è così ghiotto.", spanish="Después de todo, no conseguimos\ntraerle a [CS:N]Wigglytuff[CR] ninguna de esas\nManzanas Perfectas que tanto le gustan."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="But... After that, we did work\nreally hard, didn't we?", french="Mais nous avons quand même\ntravaillé dur, n'est-ce pas?", german="Aber danach haben wir uns doch\nrichtig angestrengt, oder?", italian="In seguito però abbiamo lavorato\nmolto duramente, non è vero?", spanish="Pero... Al fin y al cabo\nnos hemos esforzado mucho, ¿no?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="But... After that, we did work\nreally hard, didn't we?", french="Mais nous avons quand même\ntravaillé dur, n'est-ce pas?", german="Aber danach haben wir uns doch\nrichtig angestrengt, oder?", italian="In seguito però abbiamo lavorato\nmolto duramente, non è vero?", spanish="Pero... Al fin y al cabo\nnos hemos esforzado mucho, ¿no?"})
  else
  SkySceneKit.say({english="But... After that, we did work\nreally hard, didn't we?", french="Mais nous avons quand même\ntravaillé dur, n'est-ce pas?", german="Aber danach haben wir uns doch\nrichtig angestrengt, oder?", italian="In seguito però abbiamo lavorato\nmolto duramente, non è vero?", spanish="Pero... Al fin y al cabo,\nnos hemos esforzado mucho, ¿no?"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We've done the best we could.\nEven if we don't get picked, I don't regret\na thing.", french="Nous avons fait de notre mieux.\nMême si nous ne faisons pas partie de\nl'expédition, je ne regrette rien.", german="Wir haben unser Bestes gegeben.\nSelbst wenn wir nicht ausgewählt werden,\nbereue ich nichts.", italian="Abbiamo fatto del nostro meglio.\nAnche se non dovessero sceglierci, non ho\nrimorsi.", spanish="Hemos hecho lo que hemos\npodido. Aunque no nos escojan, no me\narrepiento de nada."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We've done the best we could.\nEven if we don't get picked, I don't regret\na thing.", french="Nous avons fait de notre mieux.\nMême si nous ne faisons pas partie de\nl'expédition, je ne regrette rien.", german="Wir haben unser Bestes gegeben.\nSelbst wenn wir nicht ausgewählt werden,\nbereue ich nichts.", italian="Abbiamo fatto del nostro meglio.\nAnche se non dovessero sceglierci, non ho\nrimorsi.", spanish="Hemos hecho lo que hemos\npodido. Aunque no nos escojan, no me\narrepiento de nada."})
  else
  SkySceneKit.say({english="We've done the best we could.\nEven if we don't get picked, I don't regret\na thing.", french="Nous avons fait de notre mieux.\nMême si nous ne faisons pas partie de\nl'expédition, je ne regrette rien.", german="Wir haben unser Bestes gegeben.\nSelbst wenn wir nicht ausgewählt werden,\nbereue ich nichts.", italian="Abbiamo fatto del nostro meglio.\nAnche se non dovessero sceglierci, non ho\nrimorsi.", spanish="Hemos hecho lo que hemos\npodido. Aunque no nos escojan, no me\narrepiento de nada."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Down)
  -- SetAnimation(70) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Yaaaaawn... I'm getting drowsy.\nLet's get some sleep.", french="Mouaaah... je commence à avoir\nsommeil. Nous devrions dormir.", german="Gääääähn... Ich bin müde.\nLass uns schlafen.", italian="Yaaaaawn... Sto per\naddormentarmi. Andiamo a dormire.", spanish="¡Uaaa! Me caigo de sueño.\nVamos a dormir."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yaaaaawn... I'm getting drowsy.\nLet's get some sleep.", french="Mouaaah... je commence à avoir\nsommeil. Nous devrions dormir.", german="Gääääähn... Ich bin müde.\nLass uns schlafen.", italian="Yaaaaawn... Sto per\naddormentarmi. Andiamo a dormire.", spanish="¡Uaaa! Me caigo de sueño.\nVamos a dormir."})
  else
  SkySceneKit.say({english="Yaaaaawn... I'm getting drowsy.\nLet's get some sleep.", french="Mouaaah... je commence à avoir\nsommeil. Nous devrions dormir.", german="Gääääähn... Ich bin müde.\nLass uns schlafen.", italian="Yaaaaawn... Sto per\naddormentarmi. Andiamo a dormire.", spanish="¡Uaaa! Me caigo de sueño.\nVamos a dormir."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I'm looking forward to\ntomorrow's announcement. OK, good night.", french="J'ai hâte d'être à demain,\npour l'annonce. Allez, bonne nuit.", german="Ich freue mich auf den\naufregenden Tag morgen. Gute Nacht.", italian="Non vedo l'ora di sentire\nl'annuncio di domani. Ok, buonanotte.", spanish="Me muero de ganas por saber a\nquién han elegido. Bueno, hasta mañana."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I'm looking forward to\ntomorrow's announcement. OK, good night.", french="J'ai hâte d'être à demain,\npour l'annonce. Allez, bonne nuit.", german="Ich freue mich auf den\naufregenden Tag morgen. Gute Nacht.", italian="Non vedo l'ora di sentire\nl'annuncio di domani. Ok, buonanotte.", spanish="Me muero de ganas por saber a\nquién han elegido. Bueno, hasta mañana."})
  else
  SkySceneKit.say({english="I'm looking forward to\ntomorrow's announcement. OK, good night.", french="J'ai hâte d'être à demain,\npour l'annonce. Allez, bonne nuit.", german="Ich freue mich auf den\naufregenden Tag morgen. Gute Nacht.", italian="Non vedo l'ora di sentire\nl'annuncio di domani. Ok, buonanotte.", spanish="Me muero de ganas por saber a\nquién han elegido. Bueno, hasta mañana."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  GROUND:EntTurn(partner, Direction.Right)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(76) [anim idle native]
  GAME:WaitFrames(60)
  GROUND:EntTurn(hero, Direction.DownRight)
  GAME:WaitFrames(30)
  GROUND:EntTurn(hero, Direction.Right)
  -- SetAnimation(76) [anim idle native]
  GAME:WaitFrames(50)
  GAME:FadeIn(60) -- screen_FadeChange vers alpha 192 (éclaircissement, adaptation)
  -- SetAnimation(62) [anim idle native]
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(hero) end) -- message_SetActor(ACTOR_PLAYER)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...)", french="(...)", german="(...)", italian="(...)", spanish="(...)"})
  else
  SkySceneKit.say({english="(...)", french="(...)", german="(...)", italian="(...)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(No regrets. Right...)", french="(Pas de regrets. Bien...)", german="(Keine Reue. Genau...)", italian="(Niente rimorsi. Giusto...)", spanish="(No se arrepiente. Yo tampoco...)"})
  else
  SkySceneKit.say({english="(No regrets. Right...)", french="(Pas de regrets. Bien...)", german="(Keine Reue. Genau...)", italian="(Niente rimorsi. Giusto...)", spanish="(No se arrepiente. Yo tampoco...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But...)", french="(Mais...)", german="(Aber...)", italian="(Ma...)", spanish="(Pero...)"})
  else
  SkySceneKit.say({english="(But...)", french="(Mais...)", german="(Aber...)", italian="(Ma...)", spanish="(Pero...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(If we're not chosen for the exploration\nparty...)", french="(... si nous ne faisons pas partie de\nl'expédition...)", german="(Wenn wir nicht ins Expeditionsteam gewählt\nwerden...)", italian="(... se non ci scelgono per la spedizione...)", spanish="(Sé que si no nos escogen...)"})
  else
  SkySceneKit.say({english="(If we're not chosen for the exploration\nparty...)", french="(... si nous ne faisons pas partie de\nl'expédition...)", german="(Wenn wir nicht ins Expeditionsteam gewählt\nwerden...)", italian="(... se non ci scelgono per la spedizione...)", spanish="(Sé que si no nos escogen...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([partner] will be crushed.)", french="(... ce sera très dur pour [partner].)", german="(Dann wird [partner] am Boden zerstört\nsein.)", italian="(... [partner] ci rimarrà malissimo.)", spanish="([partner] no va a poder soportarlo.)"})
  else
  SkySceneKit.say({english="([partner] will be crushed.)", french="(... ce sera très dur pour [partner].)", german="(Dann wird [partner] am Boden zerstört\nsein.)", italian="(... [partner] ci rimarrà malissimo.)", spanish="([partner] no va a poder soportarlo.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="([partner] is trying so hard... I hope\n[partner] gets to go on the exploration...)", french="([partner] a fait tant d'efforts... Je lui\nsouhaite de faire partie de l'expédition...)", german="([partner] gibt sich so viel Mühe.\nIch hoffe, [partner] darf mit auf die\nExpedition.)", italian="([partner] si sta impegnando veramente\ntanto... Spero che il suo desiderio di\npartecipare alla spedizione si avveri.)", spanish="([partner] está haciendo un esfuerzo tan\ngrande... De verdad espero que [partner]\npueda ir a la expedición...)"})
  else
  SkySceneKit.say({english="([partner] is trying so hard... I hope\n[partner] gets to go on the exploration...)", french="([partner] a fait tant d'efforts... Je lui\nsouhaite de faire partie de l'expédition...)", german="([partner] gibt sich so viel Mühe.\nIch hoffe, [partner] darf mit auf die\nExpedition.)", italian="([partner] si sta impegnando veramente\ntanto... Spero che il suo desiderio di\npartecipare alla spedizione si avveri.)", spanish="([partner] está haciendo un esfuerzo tan\ngrande... De verdad espero que [partner]\npueda ir a la expedición...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(If we both get chosen for the expedition...)", french="(S'ils me choisissent, moi aussi...)", german="(Wenn wir beide ausgewählt werden...)", italian="(Se ci scelgono per la spedizione...)", spanish="(Si nos escogiesen a los dos...)"})
  else
  SkySceneKit.say({english="(If we both get chosen for the expedition...)", french="(S'ils me choisissent, moi aussi...)", german="(Wenn wir beide ausgewählt werden...)", italian="(Se ci scelgono per la spedizione...)", spanish="(Si nos escogiesen...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(That special ability I have may be\nuseful then...)", french="(... ce don que je possède pourrait nous\nêtre d'une grande utilité...)", german="(Dann könnte diese besondere Fähigkeit von\nmir von Nutzen sein.)", italian="(... la mia abilità speciale potrebbe rivelarsi\nutile.)", spanish="(Esa capacidad especial que tengo podría\nresultar muy útil...)"})
  else
  SkySceneKit.say({english="(That special ability I have may be\nuseful then...)", french="(... ce don que je possède pourrait nous\nêtre d'une grande utilité...)", german="(Dann könnte diese besondere Fähigkeit von\nmir von Nutzen sein.)", italian="(... la mia abilità speciale potrebbe rivelarsi\nutile.)", spanish="(Esa capacidad especial que tengo podría\nresultar muy útil...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Come to think of it, I haven't had any of\nthose dizzy spells recently.)", french="(Tiens, je n'ai pas eu de vertiges récemment.)", german="(Da fällt mir auf, ich hatte in letzter Zeit gar\nkeine Schwindelanfälle mehr.)", italian="(A pensarci, è da un po' che non ho uno di quei\ncapogiri.)", spanish="(Ahora que lo pienso, no he tenido ninguno\nde esos mareos últimamente.)"})
  else
  SkySceneKit.say({english="(Come to think of it, I haven't had any of\nthose dizzy spells recently.)", french="(Tiens, je n'ai pas eu de vertiges récemment.)", german="(Da fällt mir auf, ich hatte in letzter Zeit gar\nkeine Schwindelanfälle mehr.)", italian="(A pensarci, è da un po' che non ho uno di quei\ncapogiri.)", spanish="(Ahora que lo pienso, no he tenido ninguno\nde esos mareos últimamente.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(I think it's a useful ability.)", french="(A mon avis, c'est un don très utile.)", german="(Ich glaube, es ist eine nützliche Fähigkeit.)", italian="(Penso sia un'abilità utile.)", spanish="(Creo que es una habilidad muy útil.)"})
  else
  SkySceneKit.say({english="(I think it's a useful ability.)", french="(A mon avis, c'est un don très utile.)", german="(Ich glaube, es ist eine nützliche Fähigkeit.)", italian="(Penso sia un'abilità utile.)", spanish="(Creo que es una habilidad muy útil.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(But not being able to see those visions when\nI want to is frustrating.)", french="(Mais c'est frustrant de ne pas avoir ces\nvisions quand je le souhaite.)", german="(Aber es ist frustrierend, dass ich diese\nVisionen nicht steuern kann.)", italian="(Ma non poter avere quelle visioni quando\nvoglio è frustrante.)", spanish="(Pero no poder decidir cuándo tener visiones\nresulta muy frustrante.)"})
  else
  SkySceneKit.say({english="(But not being able to see those visions when\nI want to is frustrating.)", french="(Mais c'est frustrant de ne pas avoir ces\nvisions quand je le souhaite.)", german="(Aber es ist frustrierend, dass ich diese\nVisionen nicht steuern kann.)", italian="(Ma non poter avere quelle visioni quando\nvoglio è frustrante.)", spanish="(Pero no poder decidir cuándo tener visiones\nresulta muy frustrante.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...)", french="(...)", german="(...)", italian="(...)", spanish="(...)"})
  else
  SkySceneKit.say({english="(...)", french="(...)", german="(...)", italian="(...)", spanish="(...)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Thinking about everything too much will\nkeep me from sleeping. I'd better get to sleep\nnow too.)", french="(Je n'arriverai pas à trouver le sommeil si\nje réfléchis trop. Je ferais mieux de dormir\naussi.)", german="(Wenn ich über alles zu viel nachdenke, kann\nich nicht einschlafen. Ich sollte jetzt besser\nauch schlafen.)", italian="(Pensare troppo mi terrà sveglio. Dovrei\nmettermi a dormire anche io adesso.)", spanish="(Pensar demasiado en todo esto me va a quitar\nel sueño. Será mejor que yo también\nduerma un poco.)"})
  else
  SkySceneKit.say({english="(Thinking about everything too much will\nkeep me from sleeping. I'd better get to sleep\nnow too.)", french="(Je n'arriverai pas à trouver le sommeil si\nje réfléchis trop. Je ferais mieux de dormir\naussi.)", german="(Wenn ich über alles zu viel nachdenke, kann\nich nicht einschlafen. Ich sollte jetzt besser\nauch schlafen.)", italian="(Pensare troppo mi terrà sveglia. Dovrei\nmettermi a dormire anche io adesso.)", spanish="(Pensar demasiado en todo esto me va\na quitar el sueño. Será mejor que\nyo también duerma un poco.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(Good night, [partner]. I hope you get\nchosen tomorrow...)", french="(Bonne nuit, [partner]. J'espère que ton\nnom sera annoncé demain...)", german="(Gute Nacht, [partner]. Ich hoffe, du wirst\nmorgen ausgewählt.)", italian="(Buonanotte, [partner]. Spero che ti\nscelgano domani...)", spanish="(Buenas noches, [partner]. Espero que\nmañana te seleccionen.)"})
  else
  SkySceneKit.say({english="(Good night, [partner]. I hope you get\nchosen tomorrow...)", french="(Bonne nuit, [partner]. J'espère que ton\nnom sera annoncé demain...)", german="(Gute Nacht, [partner]. Ich hoffe, du wirst\nmorgen ausgewählt.)", italian="(Buonanotte, [partner]. Spero che ti\nscelgano domani...)", spanish="(Buenas noches, [partner]. Espero que\nmañana te seleccionen.)"})
  end
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="(...)", french="(...)", german="(...)", italian="(...)", spanish="(...)"})
  else
  SkySceneKit.say({english="(...)", french="(...)", german="(...)", italian="(...)", spanish="(...)"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(30)
  -- SetAnimation(62) [anim idle native]
  GAME:WaitFrames(90)
  pcall(function() SOUND:FadeOutBGM(120) end)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(60)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V02P06A) [décor sub chargé: Sub_v02p06a]
  -- camera2_SetPositionMark(Position<'m0', 19.5, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v02p06a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(150)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(60)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" There it is! Another Time Gear!", french=" Le voilà! Un autre Rouage du Temps!", german=" Da ist es! Ein weiteres Zahnrad der Zeit!", italian=" Eccolo! Un altro Ingranaggio del Tempo!", spanish=" ¡Ahí está! ¡Otro Engranaje del Tiempo!"})
  -- message_Close
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
