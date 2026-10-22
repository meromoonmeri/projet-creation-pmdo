-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D46P11A/n08a0208.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- GAP: BGM BGM_IN_THE_FUTURE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SV.SkyScenarioSide = {main=47, sub=1} -- $SCENARIO_SIDE = scn[47,1] (ROM)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" .........", french=" .........", german=" .........", italian=" .........", spanish=" ..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ....................", french=" ....................", german=" ....................", italian=" ....................", spanish=" ... ..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...[K]Oogh...", french=" ...[K] Argh...", german=" ...[K]Uuuff...", italian=" ...[K] Oooh...", spanish=" Ah...[K] Ay..."})
  -- message_KeyWait
  GAME:FadeOut(false,  60)
  -- message_CloseEnforce
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  -- back_SetGround(LEVEL_D46P11A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  local npc_npc_yonowaaru_n8 = SkySceneKit.spawn_npc("dusknoir", 200, 272, Direction.Down, "NPC_YONOWAARU_N8")
  -- SetAnimation(36) [anim idle native]
  -- SetAnimation(29) [anim idle native]
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Ooogh...[K] OOOOooogh...", french=" Aaaargh...[K] Aaaaaaargh...", german=" Oooh...[K] UUUuuuuuuff...", italian=" Uuuh...[K] UUUuuuh...", spanish=" Aaah...[K] Aaayy..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Oof...", french=" Ouf...", german=" Oha...", italian=" Uff...", spanish=" Uf..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(31) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  GROUND:EntTurn(hero, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(20)
  -- ExecuteCommon(CORO_LOOK_AROUND_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(10)
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...[K][CS:N]Dusknoir[CR]...", french=" ... [K][CS:N]Noctunoir[CR]...", german=" ...[K][CS:N]Zwirrfinst[CR]...", italian=" ...[K] [CS:N]Dusknoir[CR]...", spanish=" Ay...[K] [CS:N]Dusknoir[CR]..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_LOOK_AROUND_LEFT_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Is this...[K]the future?", french="Sommes-nous...[K] de retour\ndans le futur?", german=" Ist das hier...[K] die Zukunft?", italian=" Questo è...[K] il futuro?", spanish=" Entonces...[K] ¿He vuelto del pasado?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I'm...[K] I'm back again...", french=" Je...[K] je suis revenu...", german=" Wieder...[K] Wieder zurück...", italian=" Sono...[K] ritornato...", spanish=" Estoy otra vez...[K] en mi época..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" This...[K]world of darkness...", french="Ce monde...[K] d'ombre\nperpétuelle...", german=" Diese...[K] Welt voller Dunkelheit...", italian="... in questo...[K] mondo di\noscurità...", spanish=" En este...[K] mundo de oscuridad..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...[K]But...", french=" ...[K] Mais...", german=" ...[K]Aber...", italian=" ...[K] Però...", spanish=" Ah...[K] Pero si..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CS:N]Dusknoir[CR] and I haven't\ndisappeared...", french="[CS:N]Noctunoir[CR] et moi\nn'avons pas disparu...", german="[CS:N]Zwirrfinst[CR] und ich\nsind wohl gar nicht verschwunden...", italian="Io e [CS:N]Dusknoir[CR] non siamo\nscomparsi...", spanish="¡[CS:N]Dusknoir[CR] y yo no hemos\ndesaparecido!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="The future's still this\ndark place...[K] Does that mean...", french="Et l'ombre règne toujours sur\nle futur...[K] Autrement dit...", german="Und die Zukunft ist immer noch\nein dunkler Ort...[K] Bedeutet das...", italian="Il futuro è ancora avvolto\nnelle tenebre...[K] Ciò significa che...", spanish="Este mundo sigue siendo\noscuro y siniestro...[K] ¿Eso significa que...?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="History...[K]history hasn't been\nchanged yet...?", french="... l'histoire...[K] le cours de\nl'histoire n'a pas encore été modifié...?", german="Wurde...[K] Wurde die Geschichte\nnoch nicht geändert?", italian="La storia...[K] non è ancora stata\ncambiata...?", spanish="La historia...[K] ¿La historia\naún no ha cambiado?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Don't tell me...", french=" Ne me dites pas que...", german=" Sag bloß...", italian=" Non sarà che...", spanish=" No quiero saberlo..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Preventing the planet's\nparalysis...[K] Did [c_name:NPC_HERO_FIRST] and\n[c_name:NPC_PARTNER_FIRST] fail...?", french="La Paralysie de la Planète...[K]\n[c_name:NPC_HERO_FIRST] et [c_name:NPC_PARTNER_FIRST] auraient échoué\ndans leur tentative de l'empêcher...?", german="Die Lähmung des Planeten\naufzuhalten...[K] Sind [c_name:NPC_HERO_FIRST] und\n[c_name:NPC_PARTNER_FIRST] etwa gescheitert?", italian="... [c_name:NPC_HERO_FIRST] e [c_name:NPC_PARTNER_FIRST]\nnon ce l'hanno fatta...[K] a impedire\nla paralisi del pianeta...?", spanish="La parálisis del planeta...[K]\n¿Han fracasado [c_name:NPC_HERO_FIRST] y [c_name:NPC_PARTNER_FIRST]\nen su misión para evitarla?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...[K]No.[K] That can't be.", french=" ...[K] Non.[K] Impossible.", german=" ...[K]Nein.[K] Das kann nicht sein.", italian=" ...[K] No.[K] Non può essere.", spanish=" No...[K] Eso...[K] no puede ser."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="It's only that they\nhaven't done it yet.", french="Ce n'est qu'une question\nde temps.", german="Anscheinend haben sie es nur\nnoch nicht vollbracht.", italian="È solo che non hanno ancora\ncompletato la missione.", spanish="Es solo que aún no han tenido\ntiempo de conseguirlo."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="The effects of history's being\nchanged will probably start appearing soon.\nI simply haven't noticed them yet...", french="La planète ne va pas tarder à\nreprendre vie. Les changements se\nmanifesteront d'ici peu.", german="Die Auswirkungen der geänderten\nGeschichte werden sicherlich bald spürbar sein.\nIch habe sie wohl einfach noch nicht bemerkt...", italian="Probabilmente gli effetti legati\nal cambiamento della storia si verificheranno\npresto. Si vede che non li ho ancora notati...", spanish="Los efectos del cambio en el pasado\nsin duda empezarán muy pronto. Es solo que\nyo todavía no he notado nada."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Anyhow...[K] Right now I've got no\nchoice but to believe that.", french="Enfin...[K] je n'ai pas d'autre choix\nque d'y croire, pour l'instant.", german="Auf jeden Fall...[K] Ich kann eh nur\nversuchen, fest daran zu glauben.", italian="In ogni caso...[K] Ora come ora non\nposso far altro che sperare.", spanish="Sea como sea...[K] ahora no tengo otra\nalternativa que suponer que eso es lo que\nha ocurrido."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[c_name:NPC_HERO_FIRST]...[K]\n[c_name:NPC_PARTNER_FIRST]...", french="[c_name:NPC_HERO_FIRST]...[K]\n[c_name:NPC_PARTNER_FIRST]...", german="[c_name:NPC_HERO_FIRST]...[K]\n[c_name:NPC_PARTNER_FIRST]...", italian="[c_name:NPC_HERO_FIRST]...[K]\n[c_name:NPC_PARTNER_FIRST]...", spanish=" [c_name:NPC_HERO_FIRST]...[K] [c_name:NPC_PARTNER_FIRST]..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Please...[K] Succeed for me.", french="Je vous en prie...[K] Faites-le\npour moi.", german="Bitte...[K]\nSeid erfolgreich. Tut es für mich.", italian="Vi prego...[K] Dovete farcela,\nper me.", spanish="Tenéis que conseguirlo...[K]\nHacedlo por mí."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I believe in you two...[K]\nI'm doing everything I can.", french="Je crois en vous...[K]\nDe toutes mes forces.", german="Ich glaube an euch beide...[K]\nIch tue ja, was ich kann.", italian="Ho fiducia in voi...[K] Da parte mia,\nfarò tutto ciò che posso.", spanish="Sé que podéis lograrlo...[K] y voy\na hacer lo posible por que así sea."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(5121) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- SetAnimation(26) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Guh...[K] My injuries from\nfighting [CS:N]Dusknoir[CR] still hurt...", french="Argh...[K] Les blessures de mon\ncombat contre [CS:N]Noctunoir[CR] sont\ntoujours aussi douloureuses...", german="Oooh...[K] Meine Verletzungen vom\nKampf gegen [CS:N]Zwirrfinst[CR] tun immer noch weh...", italian="Urgh...[K] Le ferite che ho subito\nnello scontro con [CS:N]Dusknoir[CR] mi fanno ancora\nmale...", spanish="Ay...[K] Las heridas que he sufrido\nluchando contra [CS:N]Dusknoir[CR] aún me duelen..."})
  -- message_Close
  -- SetAnimation(27) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  local npc_npc_yamirami = SkySceneKit.spawn_npc("sableye", 40, 224, Direction.Right, "NPC_YAMIRAMI")
  GROUND:MoveToPosition(npc_npc_yamirami, 176, 224, false, 2)
  GAME:WaitFrames(45)
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(hero, Direction.Left)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" [CS:N]S-[K]Sableye[CR]!", french=" [CS:N]T-[K]Ténéfix[CR]!", german=" [CS:N]Z-[CR][K][CS:N]Zobiris[CR]!", italian=" [CS:N]S-[CR][K][CS:N]Sableye[CR]!", spanish=" [CS:N]Sa[CR]...[K] ¡[CS:N]Sableye[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock_Bad") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yamirami) end)
  SkySceneKit.say({english="Wheh-heh-heh!?[K]\n[CS:Y]G-Grovyle[CR]?!", french="Whé hé hé!?[K]\n[CS:Y]M-Massko[CR]?!", german="Wähähäh?!?[K]\n[CS:Y]R-Reptain[CR]?!?", italian="Meh-eh-eh!?[K]\n[CS:Y]G-[CR][K][CS:Y]Grovyle[CR]?!", spanish="¡Je, je![K] ¿Je?\n[CS:Y]Gro[CR]... ¡¿[CS:Y]Grovyle[CR]?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_yamirami, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  do local p=npc_npc_yamirami.Position; GROUND:MoveToPosition(npc_npc_yamirami, p.X+(-160), p.Y+(0), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...[K]They've found me already...", french=" ...[K] Ils m'ont déjà repéré...", german="...[K]\nSie haben mich schon aufgespürt...", italian=" ...[K] Mi hanno già trovato...", spanish=" ¡No![K] Ya me han encontrado..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I've got to get out of here as\nfast as I can.", french="Je dois quitter cet endroit\nau plus vite.", german="Ich muss hier weg,\nso schnell wie möglich.", italian="Devo andarmene da qui\nil prima possibile.", spanish="Tengo que salir de aquí\nlo antes posible."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_FOR_A_NEW_LIFE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- SetAnimation(37) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  do local p=npc_npc_yonowaaru_n8.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n8, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yonowaaru_n8.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n8, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yonowaaru_n8.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n8, p.X+(-1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(3)
  do local p=npc_npc_yonowaaru_n8.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n8, p.X+(1), p.Y+(0), false, 2) end -- SlidePositionOffset
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Ugh...", french=" Argh...", german=" Uff...", italian=" Uuuh...", spanish=" Ay..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.DownLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...! ([CS:N]Dusknoir[CR]!)", french=" ...! ([CS:N]Noctunoir[CR]!)", german=" ...([CS:N]Zwirrfinst[CR]!)", italian=" ...! ([CS:N]Dusknoir[CR]!)", spanish=" ¡Ah! (¡[CS:N]Dusknoir[CR]!)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Ugh...[K] [CS:Y]Grovyle[CR]!", french=" Argh...[K] [CS:Y]Massko[CR]!", german=" Uff...[K] [CS:Y]Reptain[CR]!", italian=" Uuuh...[K] [CS:Y]Grovyle[CR]!", spanish=" Ay...[K] ¡[CS:Y]Grovyle[CR]!"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" [CS:Y]Grovyle[CR]![K] YOOOOUUUU!!", french=" [CS:Y]Massko[CR]![K] TOI ICI!!", german=" [CS:Y]Reptain[CR]![K] DUUUUUUU!!!", italian=" [CS:Y]Grovyle[CR]![K] TUUUUUU!!!", spanish=" ¡[CS:Y]Grovyle[CR]![K] ¡¡Es todo culpa tuya!!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(-24), 16, false) end) -- MovePositionOffset performer/caméra
  GROUND:MoveToPosition(npc_npc_yonowaaru_n8, 220, 244, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  -- SetAnimation(38) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Ugh!", french=" Argh!", german=" Uff!", italian=" Oooh!", spanish=" ¡Ay!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="It looks like our fight left you\nwith some injuries too.", french="Il semblerait que tu ne sois pas\nsorti indemne de notre combat.", german="Anscheinend hat dich unser\nKampf auch etwas in Mitleidenschaft gezogen.", italian="A quanto pare, il nostro scontro\nha lasciato qualche segno anche su di te.", spanish="Parece que tú tampoco\nhas salido indemne de nuestra lucha."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Don't push yourself.", french=" N'en fais pas trop.", german=" Sei nicht zu hart mit dir selbst.", italian="È meglio che tu ti dia\nuna calmata.", spanish=" No te esfuerces."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Y-you! [CS:Y]Grovyle[CR]![K]\nUgh...[K] Augghh...", french="Toi! [CS:Y]Massko[CR]![K]\nArgh...[K] Aaaargh...", german="D-du! [CS:Y]Reptain[CR]![K]\nUff...[K] Ouuff...", italian="T-Tu! [CS:Y]Grovyle[CR]![K]\nUrgh...[K] Ooohhh...", spanish="¡Tú! ¡[CS:Y]Grovyle[CR]![K]\nAy...[K] Aaah..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" This...[K] This is...[K]the future...?", french=" Serait-ce...[K] le futur...?", german=" Ist...[K] Ist das...[K] die Zukunft?", italian=" Questo...[K] è...[K] il futuro...?", spanish=" Estamos...[K] en...[K] ¿el futuro?"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I knew I'd come right\nback here...[K] To this world...", french="J'ai toujours su que je\nreviendrais...[K] dans ce monde...", german="Ich wusste, ich würde genau\nhierher zurückkehren...[K] In diese Welt...", italian="Sapevo che sarei ritornato qui...[K]\nIn questo mondo...", spanish="Sabía que regresaría\naquí...[K] a este mundo."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- MoveHeight(1, 2) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(1, 0) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(2)
  -- MoveHeight(1, 2) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(1, 0) [élévation d'objet NDS non simulée - documenté]
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" .........", french=" .........", german=" .........", italian=" .........", spanish=" ..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" ...[K]Heh...[K] Heh heh heh heh heh...", french=" ...[K] Ha...[K] Ha ha ha ha ha...", german=" ...[K]He...[K] Hehehehehe...", italian=" ...[K] Eh...[K] Eh eh eh eh eh...", spanish=" Ja...[K] Ja, ja...[K] ¡Jua, jua, jua, jua!"})
  -- MoveHeight(1, 2) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(1, 0) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(2)
  -- MoveHeight(1, 2) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(1, 0) [élévation d'objet NDS non simulée - documenté]
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Complain") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="After all...[K] After all, didn't I\nlose...[K]to you...", french="Après tout...[K] vous avez fini par\nl'emporter...", german="Immerhin...[K] Immerhin habe ich\nnicht...[K] Ich habe nicht gegen dich verloren...", italian="Dopotutto...[K] Dopotutto non\nho perso...[K] contro di te...", spanish="Así que...[K] después de todo...[K]\nno he perdido contra ti."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" [CS:Y]Grovyle[CR] and [c_name:NPC_HERO_FIRST]... I...", french=" Toi et [c_name:NPC_HERO_FIRST]... Je...", german=" [CS:Y]Reptain[CR] und [c_name:NPC_HERO_FIRST]... Ich...", italian=" [CS:Y]Grovyle[CR] e [c_name:NPC_HERO_FIRST]... Io...", spanish=" [CS:Y]Grovyle[CR] y [c_name:NPC_HERO_FIRST]... No..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I couldn't get in your way.\nHeh heh heh...", french="Je n'ai pas réussi à vous\narrêter. Ha ha ha...", german="Ich konnte euch nicht aufhalten.\nHehehe...", italian="Non sono riuscito a mettervi\ni bastoni tra le ruote. Eh eh eh...", spanish="Y eso que no pude deteneros.\nJa, ja, ja..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" .........", french=" .........", german=" .........", italian=" .........", spanish=" ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" ...[K]But...[K] Why...", french=" ...[K] Mais...[K] Pourquoi...", german=" ...[K]Aber...[K] Warum...", italian=" ...[K] Eppure...", spanish="Y todo...[K] ¿por qué?[K]\nSupongo que eso estarás pensando."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="I don't want to disappear...[K]\nThat's all, I just don't want to disappear...", french="Quant à moi, je refuse de\ndisparaître...[K] Un point c'est tout...", german="Ich möchte nicht verschwinden...[K]\nDas ist alles. Ich möchte nicht verschwinden...", italian="Non voglio scomparire...[K]\nNon voglio, tutto qui...", spanish="No quiero desaparecer...[K]\n¿Te parece poco motivo?"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Yet...[K] Why did you...", french=" Mais, toi...[K] Pourquoi donc as-tu...", german=" Aber...[K] Warum hast du...", italian=" E allora...[K] perché tu...", spanish=" Pero tú...[K] ¿Por qué...?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="You saw the world of the past,\ndidn't you?", french="Tu as vu ce qu'était le monde\ndans le passé, n'est-ce pas?", german="Du hast doch die Welt der\nVergangenheit gesehen, nicht wahr?", italian="Hai visto il mondo del passato,\nno?", spanish="Has visto cómo es el mundo\ndel pasado, ¿verdad?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="The beauty of a sunrise.[K] The\npeacefulness of a gentle breeze.", french="La beauté d'un lever de soleil.[K]\nLa douce caresse de la brise.", german="Die Anmut eines Sonnenaufgangs.[K]\nDie Friedlichkeit eines sanften, lauen Luftzugs.", italian="Lo spettacolo dell'alba che sorge.[K]\nUna brezza delicata che carezza dolcemente\nil tuo volto.", spanish="La belleza del amanecer.[K]\nLa paz de una suave brisa."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="There's no future in this dark\nworld--it's enough to break your heart.", french="Il n'y a pas d'avenir dans\nun monde englouti par les ombres.\nC'est à vous briser le cœur.", german="In dieser dunklen Welt hingegen\ngibt es keine Hoffnung mehr. Das genügt,\num einem das Herz zu brechen.", italian="In questo mondo tenebroso\nnon esiste futuro... Ovunque è tristezza\ne desolazione.", spanish="Este mundo siniestro no merece\nla pena. Esto no es vida."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I don't want to disappear,\neither...", french="Moi non plus, je ne tiens pas\nà disparaître...", german="Ich möchte\nauch nicht verschwinden...", italian=" Nemmeno io voglio sparire...", spanish="Yo tampoco quiero desaparecer,\n¿sabes?"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="But if history could be changed...[K]\nI'm willing to pay that price.", french="Mais si c'est le prix à payer\npour changer le cours de l'histoire...[K]\nalors, je suis prêt à me sacrifier.", german="Aber wenn die Chance besteht,\nden Ablauf der Geschichte zu verändern...[K]\nDann bin ich bereit, diesen Preis zu zahlen.", italian="Ma se possiamo cambiare\nla storia...[K] allora sono disposto a pagarne\nil prezzo.", spanish="Pero si se pudiera cambiar\nla historia...[K] yo asumiría las consecuencias."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Even if we disappeared...[K]\nIt would be for the sake of everyone who\nlives in the future...", french="Si nous disparaissons...[K]\nnous le ferons pour tous les Pokémon\ndu futur...", german="Würden wir verschwinden...[K]\nDann wäre das im Sinne der Zukunft aller...", italian="Anche se dovessimo sparire...[K]\nl'avremo fatto per il bene di tutti coloro\nche vivono nel futuro...", spanish="Aunque desapareciéramos.[K]\nAl menos sería por el bien de las generaciones\nfuturas."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Everyone--everything--from\nnow on would be given a gift...[K]of a new life.", french="Pour leur donner un bel avenir.\n[K]L'espoir d'une vie nouvelle.", german="Allen und allem wäre von jenem\nAugenblick ein Geschenk gemacht worden.\nDie Möglichkeit...[K] Ein Neuanfang!", italian="A chiunque... a qualsiasi cosa...\nverrà fatto dono...[K] di una nuova speranza.", spanish="Este mundo, junto con todo y\ntodos los que habitan en él, tendría una\nnueva oportunidad...[K] Una nueva vida."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" For...[K]a new life...", french=" L'espoir...[K] d'une vie nouvelle...", german=" Ein...[K] Neuanfang...", italian=" Per...[K] una nuova esistenza...", spanish=" Por...[K] una nueva vida..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="According to the planetary\ninvestigation team, everyone, except those few\nwhose hearts are dark and shriveled...", french="D'après les enquêtes menées sur\nla planète, tous ceux dont le cœur n'est pas\nnoirci par l'ombre omniprésente...", german="Beobachtungen über den Zustand\ndes Planeten zufolge waren fast alle mit der\nMaßnahme einverstanden.", italian="Secondo la squadra\nd'investigazione planetaria, tutti, ad eccezione\ndi chi ha un cuore gonfio di malvagità...", spanish="Según una investigación que se\nha realizado en todo el mundo, todos, salvo\naquellos con el corazón totalmente oscuro..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Everyone was in agreement.", french=" Ils étaient d'accord.", german="Nur die wenigen, deren Herzen\nschon dunkel und vertrocknet waren, bildeten\nda eine Ausnahme.", italian=" ... erano d'accordo.", spanish=" Todos estaban de acuerdo."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="They all agreed to change this\nworld of darkness.", french="Tous voulaient changer ce monde\nde ténèbres.", german="Alle waren einverstanden, diese\nWelt der Dunkelheit zu verändern.", italian="Tutti hanno accettato\ndi cambiare questo mondo oscuro.", spanish="Todos querían cambiar este\nmundo de tinieblas."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Everyone's ready.", french=" Tout le monde est prêt.", german=" Und alle sind dafür bereit.", italian=" Sono tutti pronti.", spanish="Todos están listos para dejar\ntodo esto atrás."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="So do the right thing\nand give up.", french="Alors prends la bonne décision:\nabandonne.", german="Also triff die richtige\nEntscheidung und gib auf.", italian="Quindi fai la cosa giusta\ne rassegnati.", spanish=" Así que deberías rendirte."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:MoveToPosition(hero, 228, 164, false, 2)
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Where will you go?", french=" Où vas-tu aller?", german=" Wohin wirst du gehen?", italian=" Dove stai andando?", spanish=" ¿Adónde vas?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="The [CS:N]Sableye[CR] found me earlier.[K]\nWhile you were still unconscious.", french="Les [CS:N]Ténéfix[CR] m'ont repéré tout\nà l'heure.[K] Tu n'avais pas encore repris\nconnaissance.", german="Die [CS:N]Zobiris[CR] haben mich schon\naufgespürt.[K] Vorhin, während deiner Ohnmacht.", italian="I [CS:N]Sableye[CR] mi hanno scoperto.[K]\nMentre eri ancora privo di sensi.", spanish="Los [CS:N]Sableye[CR] han estado aquí.[K]\nTú seguías inconsciente."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Your failure...[K] They'll probably\ntell Primal [CS:N]Dialga[CR] about it.", french="Tu as échoué...[K] Et ils vont sans\ndoute le dire à [CS:N]Dialga[CR] Primal.", german="Deine Niederlage...[K] Sie werden\n[CS:N]Schatten-Dialga[CR] wohl davon berichten.", italian="E il tuo fallimento...[K]\nProbabilmente lo riferiranno\na [CS:N]Dialga[CR] Oscuro.", spanish="Probablemente...[K] vayan a darle\nnoticias de tu fracaso al [CS:N]Dialga Primario[CR]."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="If that happens, Primal [CS:N]Dialga[CR]\nwill likely go with Plan B.", french="Et alors, [CS:N]Dialga[CR] Primal\nse rabattra sûrement sur le plan B.", german="Wenn das geschieht, dürfte\n[CS:N]Schatten-Dialga[CR] Plan B einleiten.", italian="Se accade, [CS:N]Dialga[CR] Oscuro\npotrebbe ricorrere al piano B.", spanish="Cuando se entere, seguramente\n[CS:N]Dialga[CR] recurra a un plan B."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="But in order to send a new\nagent back to the past world...", french="Mais, pour envoyer un autre\nagent dans le passé...", german="Aber um einen neuen Gehilfen\nin die Welt der Vergangenheit zu senden...", italian="Ma per spedire un nuovo agente\nnel passato...", spanish="Pero para poder enviar a un nuevo\nagente al pasado..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="[CS:N]Dialga[CR] needs some time\nto store power.", french="[CS:N]Dialga[CR] a besoin de temps pour\nconcentrer ses forces.", german="Dazu braucht [CS:N]Dialga[CR] etwas Zeit.\nEs muss erst seine Kräfte sammeln.", italian="[CS:N]Dialga[CR] ha bisogno di tempo\nper accumulare energia.", spanish="[CS:N]Dialga[CR] necesita más tiempo\npara acumular energía."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" So...[K] I'm going to fight him now.", french="C'est pourquoi...[K] je vais le\ncombattre tout de suite, sans lui laisser\nle temps de se retourner.", german="Deswegen werde ich jetzt\naufbrechen und mich ihm im Kampf stellen.", italian="Quindi...[K] devo sconfiggerlo\nadesso.", spanish="Por eso...[K] debo enfrentarme\na él ahora mismo."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I'm going to [CS:P]Temporal Tower[CR].[K]\nTo take on Primal [CS:N]Dialga[CR].", french="Je pars pour la [CS:P]Tour du Temps[CR].[K]\nJe vais affronter [CS:N]Dialga[CR] Primal.", german="Ich gehe zum [CS:P]Zeitturm[CR].[K]\nDort stelle ich mich [CS:N]Schatten-Dialga[CR] entgegen.", italian="Andrò alla [CS:P]Torre del Tempo[CR]...[K]\nper affrontare [CS:N]Dialga[CR] Oscuro.", spanish="Voy a la [CS:P]Torre del Tiempo[CR].[K]\nY me enfrentaré al [CS:N]Dialga Primario[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n8, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Do you think you can defeat\nMaster [CS:N]Dialga[CR]?", french="Tu ne crois pas sérieusement\navoir la moindre chance face à Maître [CS:N]Dialga[CR]?", german="Glaubst du wirklich, du hast eine\nChance, Meister [CS:N]Dialga[CR] zu besiegen?", italian="Pensi davvero di poter\nsconfiggere [CS:N]Dialga[CR] Oscuro?", spanish="¿Crees que tienes alguna posibilidad\nfrente a [CS:N]Dialga[CR]?"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="You're already wounded from\nour battle.", french="Qui plus est, tu es déjà en\npiteux état, après notre combat.", german="Du bist immer noch angeschlagen\nvon unserem Kampf.", italian="Non sei ancora guarito\ndalle ferite che hai rimediato\ndurante il nostro scontro.", spanish="Ya estás bastante lastimado\npor nuestra batalla."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="You'd have to be in perfect\nshape to even consider such\nan enormous challenge...", french="Il te faudrait être en pleine\npossession de tes moyens pour ne serait-ce\nqu'envisager un tel défi...", german="Du solltest wirklich in perfekter\nVerfassung sein, um überhaupt an eine derartig\ngewaltige Herausforderung zu denken...", italian="Devi essere in forma perfetta\nse vuoi anche solo pensare di affrontare\nuna sfida così impegnativa...", spanish="Tendrías que estar en perfecta\nforma para poder plantearte siquiera\nsemejante desafío..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="You'd never win in the state\nyou're in now.", french="Tu ne l'emporteras jamais\ndans cet état.", german="Das ist gefährlich. Du hast keine\nChance, wenn du es in deiner jetzigen\nVerfassung versuchst.", italian="Non ce la farai mai nello stato\nin cui ti trovi ora.", spanish="Es imposible que ganes en tu estado\nactual."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" I already know I won't win.", french="Le combat est perdu d'avance,\net je le sais.", german="Ich weiß bereits, dass ich nicht\ngewinnen kann.", italian=" So già che non vincerò.", spanish=" Ya sé que no puedo ganar."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" What?", french=" Quoi?", german=" Was?", italian=" Cosa?", spanish=" ¿Qué estás diciendo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Until [c_name:NPC_HERO_FIRST] and\n[c_name:NPC_PARTNER_FIRST] change history...", french="Jusqu'à ce que [c_name:NPC_HERO_FIRST] et\n[c_name:NPC_PARTNER_FIRST] changent le cours de l'histoire...", german="Bis [c_name:NPC_HERO_FIRST] und\n[c_name:NPC_PARTNER_FIRST] wirklich den Verlauf\nder Geschichte ändern...", italian="Fino a quando [c_name:NPC_HERO_FIRST] e\n[c_name:NPC_PARTNER_FIRST] non cambieranno la storia...", spanish="Hasta que [c_name:NPC_HERO_FIRST] y\n[c_name:NPC_PARTNER_FIRST] puedan cambiar la historia..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Until the effects of changing\nhistory start to appear in this dark world...", french="... et que le changement\ncommence à se faire sentir dans ce monde...", german="Bis die Auswirkungen dieser\nVeränderung am Verlauf der Geschichte in\ndieser dunklen Welt spürbar werden...", italian="Fino a quando non inizieremo\na vedere gli effetti di questo cambiamento\nnel nostro mondo oscuro...", spanish="Hasta que los efectos de ese\ncambio no empiecen a mostrarse\nen este mundo de sombras..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Until then, I want to buy them\nsome time, that's all.[K] So stay out of my way.", french="... je ne cherche qu'à leur faire\ngagner du temps, c'est tout.\n[K]Hors de mon chemin.", german="Bis dahin möchte ich ihnen etwas\nZeit verschaffen.[K] Also geh mir aus dem Weg.", italian="Fino ad allora, voglio guadagnare\nun po' di tempo, ecco tutto.[K] Quindi vedi\ndi non intralciarmi!", spanish="Hasta entonces, solo quiero\nganar algo de tiempo para ellos.[K]\nAsí que apártate de mi camino."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(210) end)
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.Up)
  GROUND:MoveToPosition(hero, 228, 132, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(120)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" I...[K] I won't let you do that!", french="Jamais...[K] Il faudra me passer\nsur le corps!", german="Ich...[K]\nDas werde ich nicht zulassen!", italian=" Non...[K] ti permetterò di farlo!", spanish=" Yo...[K] ¡No pienso permitirlo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_yonowaaru_n8.Position; GROUND:MoveToPosition(npc_npc_yonowaaru_n8, p.X+(8), p.Y+(-16), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- GAP: se_Play(5143) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 2) -- screen_WhiteOut
  GAME:WaitFrames(2)
  GAME:FadeIn(2)
  pcall(function() GROUND:CharSetEmote(npc_npc_yonowaaru_n8, "shock", 1) end)
  -- SetAnimation(38) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english=" Ugh!", french=" Argh!", german=" Urks!", italian=" Urgh!", spanish=" ¡Ay!"})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="Blast![K] Still too weakened...\nCan't move...", french="Fichtre![K] Je suis trop affaibli...\nImpossible de bouger...", german="Oje![K] Noch zu schwach...\nKann mich nicht bewegen...", italian="No![K] Sono ancora troppo debole...\nNon riesco a muovermi...", spanish="¡Rayos![K] Sigo estando muy\ndébil... No puedo ni moverme..."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="But--[K][CS:Y]Grovyle[CR] can't just do as he\npleases!", french="Cela dit... [K][CS:Y]Massko[CR] ne s'en tirera\npas si facilement!", german="Aber...[K] [CS:Y]Reptain[CR] kann nicht\neinfach tun und lassen, was er will!", italian="Ma...[K] non posso permettere\na [CS:Y]Grovyle[CR] di fare ciò che vuole!", spanish="Pero...[K] ¡[CS:Y]Grovyle[CR], no dejaré\nque te salgas con la tuya!"})
  -- message_Close
  -- SetAnimation(22) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  GROUND:EntTurn(npc_npc_yonowaaru_n8, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_yonowaaru_n8, 228, 132, false, 1)
  GAME:WaitFrames(90)
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(90)
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="[CN]The Special Episode\n[CN]\"In the Future of Darkness\"\n[CN]stars [CS:Y]Grovyle[CR] as the main character.", french="[CN][CS:Y]Massko[CR] est le personnage principal\n[CN]de l'Episode Spécial intitulé\n[CN]\"Dans l'Ombre du Futur\".", german="[CN]Die Bonusepisode\n[CN][F:S2]In der dunklen Zukunft[F:E2]\n[CN]mit [CS:Y]Reptain[CR] in der Hauptrolle.", italian="[CN]L'episodio speciale\n[CN]\"Salto nel futuro oscuro!\"\n[CN]ha come protagonista [CS:Y]Grovyle[CR].", spanish="[CN]El capítulo especial\n[CN]\"En un futuro oscuro\" tiene\n[CN]a [CS:Y]Grovyle[CR] por protagonista."})
  pcall(function() UI:SetSpeaker("Dusknoir", true, "dusknoir", 0, '', RogueEssence.Data.Gender.Unknown) end) -- locuteur NPC_YONOWAARU (espèce ROM, sans placement zone)
  SkySceneKit.say({english="[CN]You will progress through the story with\n[CN][CS:Y]Grovyle[CR] as the playable character.", french="[CN]Vous incarnerez [CS:Y]Massko[CR].", german="[CN]Du wirst die Geschichte mit [CS:Y]Reptain[CR]\n[CN]als spielbarem Charakter bestreiten.", italian="[CN]In questa storia impersonerai [CS:Y]Grovyle[CR].", spanish="[CN]Avanzarás en la historia\n[CN]con [CS:Y]Grovyle[CR]."})
  -- message_Close
  -- main_EnterDungeon(133, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
