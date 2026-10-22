-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D57P41A/n04a1003.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Rising Fear.ogg", true) end)
  -- back_SetGround(LEVEL_D57P41A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(1) [anim idle native]
  -- bgm_ChangeVolume(60,256) [volume BGM non scriptable en Lua PMDO: piste maintenue - documenté]
  -- screen2_FadeIn(0, 30) [sub révélé en mode système NDS (aucun décor chargé): pas de contenu narratif - documenté]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  SkySubScreen.Hide(1) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ... (Invincible...[K][CS:N]Haunter[CR]!)", french=" ... ([CS:N]Spectrum[CR]...[K] l'Invincible!)", german=" ...(Unbesiegbarer...[K] [CS:N]Alpollo[CR]!)", italian=" ... (L'invincibile...[K][CS:N]Haunter[CR]!)", spanish=" Ay... ([CS:N]Haunter[CR] es...[K] ¡invencible!)"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  local npc_npc_goosuto = SkySceneKit.spawn_npc("haunter", 224, 184, Direction.Down, "NPC_GOOSUTO")
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" Heh heh heh!", french=" Hé hé hé!", german=" Hehehe!", italian=" Eh eh eh!", spanish=" ¡Je, je, je!"})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="It doesn't matter how much\ndamage I receive. It doesn't faze me at all.", french="Peu importe la quantité de\ndégâts qu'on m'inflige. Ça ne m'affecte pas\nle moins du monde.", german="Ganz egal, wie viel Schaden ich\nabbekomme. Das macht mir gar nichts aus!", italian="Per quanti colpi io subisca,\nnon ricevo nessun danno.", spanish="Por más daño que reciba,\nno me hace ni un rasguño."})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="Compared to you... You feel the\ndamage from battles.", french="Alors que toi... tu subis des\ndommages pendant un combat.", german="Anders als bei dir... Du kriegst\nim Kampf ordentlich was ab.", italian="Tu invece non hai questa\ncapacità.", spanish="Mírate a ti... Tú recibes daño\nen combate."})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="And eventually you'll\nget tired...[K] And you know who will fall\nto the ground first...", french="Et au bout du compte tu\nte fatigues...[K] Et on sait tous les deux\nqui s'écroulera en premier...", german="Und letzten Endes wirst du\nermüden...[K] Daher weißt du bereits, wer von\nuns beiden heute zuerst aufgeben wird...", italian="Alla fine sarai troppo stanca...[K]\nE a quel punto sappiamo bene entrambi\nchi andrà KO per primo...", spanish="Al final te acabarás cansando...[K]\nY quien morderá el polvo primero..."})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english="It will be you![K]\nAnd all explorers who come after me\nand try to catch me!", french="Toi![K]\nC'est la même chose pour tous ceux\nqui essayent de m'arrêter!", german="Und zwar du![K] So wie alle\nanderen Erkunder, die hier waren und\nversuchten, mich zu stellen!", italian="Tu![K] E lo stesso destino attende\ntutti gli esploratori che mi danno la caccia\nper fermarmi!", spanish="¡Vas a ser tú![K]\n¡Y cualquier explorador que venga\na intentar capturarme!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Sweatdrop") end)
  pcall(function() GROUND:CharSetEmote(hero, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Ooohhhh...", french=" Ooooooh...", german=" Oooh...", italian=" Ooohhh...", spanish=" Jo..."})
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" Get it?!", french=" Pigé?!", german=" Verstehst du?!?", italian=" Hai capito adesso?!", spanish=" ¡¿Lo captas ya?!"})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" It's impossible to catch me!", french=" Personne ne peut m'attraper!", german=" Mich zu fassen ist unmöglich!", italian=" Catturarmi è impossibile!", spanish=" ¡Es imposible atraparme!"})
  pcall(function() UI:SetSpeaker(npc_npc_goosuto) end)
  SkySceneKit.say({english=" You should just give up already!", french="Tu ferais bien mieux\nd'abandonner tout de suite!", german=" Nun gib schon endlich auf!", italian=" Lascia perdere, è meglio!", spanish=" ¡Deberías rendirte de una vez!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(150) end)
  GROUND:EntTurn(npc_npc_goosuto, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(15)
  -- GAP: se_Play(9991) — id SE NDS sans portage PMDO identifié
  -- SetOutputAttribute(64) [neutre/état moteur]
  GAME:WaitFrames(60) -- back_SetEffect(12, 60) [transition couches décor NDS: durée ROM préservée, bascule documentée]
  do local p=npc_npc_goosuto.Position; GROUND:MoveToPosition(npc_npc_goosuto, p.X+(0), p.Y+(-64), false, 1) end
  GAME:WaitFrames(2) -- WaitBackEffect (join)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  -- bgm2_PlayFadeIn(BGM_HEAVY_WIND2) [canal BGM sub: PMDO n'a qu'un canal; hors TOP_FOCUS le principal garde la main - adaptation documentée]
  GAME:WaitFrames(2) -- join WaitSe
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" .........", french=" .........", german=" ..........", italian=" ..........", spanish=" ..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ..............", french=" ..............", german=" ...............", italian=" ...............", spanish=" ... ..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" .........................", french=" .........................", german=" .........................", italian=" .........................", spanish=" ... ... ..."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharSetEmote(hero, "angry", 1) end)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Oh my gosh![K] I'm not\nlistening to you!", french=" Ben mince alors![K] Cause toujours!", german="Auweia![K] Ich werde dir einfach\nnicht mehr zuhören!", italian="Shock![K] Non ho intenzione\ndi ascoltarti!", spanish="¡Jo, pero qué dices![K] ¡Pues no\nme da la gana de hacerte caso!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="Do you think a little setback like\nthis is enough to get me to give up?!", french="Tu crois qu'un petit contretemps\ncomme ça suffit pour me faire abandonner?!", german="Du denkst, ein kleiner\nRückschlag wie dieser reicht aus, damit ich\naufgebe?!?", italian="Pensi che un piccolo\ncontrattempo del genere sia sufficiente\nper scoraggiarmi?!", spanish="¡¿En serio crees que me voy a\nrendir por un contratiempo de nada?!"})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english="I will chase you down and arrest\nyou, just you wait and see!", french="Je te pourchasserai et je finirai\npar t'arrêter, tu ne perds rien pour attendre!", german="Ich werde dich weiter jagen und\nam Ende festnehmen! Da kannst du sicher sein!", italian="Non smetterò di darti la caccia\ne alla fine ti arresterò! Aspetta e vedrai!", spanish="Pienso capturarte y arrestarte,\n¡espera y verás!"})
  -- message_Close
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(60)
  pcall(function() GROUND:CharSetEmote(hero, nil, 0) end) -- EFFECT_NONE
  GAME:WaitFrames(45)
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" ...[K]But...", french=" ...[K] Mais...", german=" ...[K]Nur...", italian=" ...[K] Ma...", spanish=" Hum...[K] Pero..."})
  pcall(function() UI:SetSpeaker(hero) end)
  SkySceneKit.say({english=" Why...[K]why is he invincible...", french="Pourquoi...[K]\npourquoi est-il invincible...?", german="Warum...[K]\nWarum ist er unbesiegbar?", italian="Come...[K] Come mai non riesco\na sconfiggerlo...?", spanish=" Por qué...[K] Por qué será invencible..."})
  -- message_Close
  -- bgm2_FadeOut [canal BGM sub: voir bgm2_Play]
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(2) -- join WaitBgm2
  -- main_EnterDungeon(160, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
