-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D12P41A/m12a1001.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_D12P41A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(3) [neutre/état moteur]
  -- supervision_Acting(4) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(1) [anim idle native]
  -- SetOutputAttribute(4) [neutre/état moteur]
  -- GAP: BGM BGM_STATIC_NOISE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  GAME:FadeIn(30)
  local npc_npc_raiboruto = SkySceneKit.spawn_npc("manectric", 280, 200, Direction.Down, "NPC_RAIBORUTO")
  pcall(function() UI:SetSpeaker(npc_npc_raiboruto) end)
  SkySceneKit.say({english=" Rrroooaarrr!", french=" Grrrrrr!", german=" Rrroooaarrr!", italian=" Rrroooaarrr!", spanish=" ¡Grrrrrrrrr!"})
  pcall(function() UI:SetSpeaker(npc_npc_raiboruto) end)
  SkySceneKit.say({english=" You...you dare?!", french="Comment... comment\nosez-vous?!", german=" Ihr... Ihr wagt es?!?", italian=" Come... Come osate...", spanish=" ¡¿Cómo... os atrevéis?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" W-wait!", french=" Attends une seconde!", german=" W-warte!", italian=" A-Aspetta!", spanish=" ¡Es... espera!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" W-w-wait a second!", french=" Attends une seconde!", german=" W-w-warte eine Sekunde!", italian=" A-Aspetta un momento!", spanish=" ¡Es... espera un momento!"})
  else
  SkySceneKit.say({english=" W-w-wait just a second!", french=" Attends une seconde!", german=" W-w-warte nur eine Sekunde!", italian=" A-Aspetta un momento!", spanish=" ¡Es... espera un momento!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We didn't come here to make\nclaims on your territory!", french="On n'est pas là pour faire main\nbasse sur votre territoire!", german="Wir sind nicht gekommen, um\neuch euer Revier streitig zu machen!", italian="Non sapevamo di invadere il\nvostro territorio!", spanish="¡No hemos venido a arrebataros\nvuestro territorio!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We honestly haven't come here\nto make claims on your territory!", french="On n'est pas là pour faire main\nbasse sur votre territoire!", german="Wir sind ganz ehrlich nicht hier,\num euch euer Revier streitig zu machen!", italian="Non sapevamo di invadere il\nvostro territorio!", spanish="¡No hemos venido a arrebataros\nvuestro territorio!"})
  else
  SkySceneKit.say({english="We honestly didn't come here to\nmake claims on your territory!", french="On n'est pas là pour faire main\nbasse sur votre territoire!", german="Wir sind ganz ehrlich nicht hier,\num euch euer Revier streitig zu machen!", italian="Non sapevamo di invadere il\nvostro territorio!", spanish="¡No hemos venido a arrebataros\nvuestro territorio!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharSetEmote(npc_npc_raiboruto, "shock", 1) end)
  pcall(function() UI:SetSpeaker(npc_npc_raiboruto) end)
  SkySceneKit.say({english=" Enough! Take this!", french=" Ça suffit! Prenez ça!", german=" Genug! Nehmt das!", italian=" Silenzio! Prendete questo!", spanish=" ¡Basta! ¡Tomad esto!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:FadeOutBGM(10) end)
  -- GAP: se_Play(6926) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  pcall(function() GROUND:CharSetEmote(partner, "shock", 1) end)
  -- Destroy() [neutre/état moteur]
  -- GAP: SetEffect EFFECT_LIGHT_EXPLOSION — VFX sans émote PMDO équivalente
  GAME:WaitFrames(10)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Waaah!", french=" Ouaaah!", german=" Waaah!", italian=" Aaaah!", spanish=" ¡Aaaah!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Waaah!", french=" Ouaaah!", german=" Waaah!", italian=" Aaaah!", spanish=" ¡Aaaah!"})
  else
  SkySceneKit.say({english=" Waaah!", french=" Ouaaah!", german=" Waaah!", italian=" Aaaah!", spanish=" ¡Aaaah!"})
  end
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  -- SetAnimation(18) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(10)
  -- GAP: SetEffect EFFECT_LIGHT_EXPLOSION_LIGHTNING — VFX sans émote PMDO équivalente
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(0), g.ViewCenter.Y+(64), 32, false) end) -- MovePositionOffset performer/caméra
  GAME:WaitFrames(10)
  -- SetAnimation(5) [anim idle native]
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(8), false, 2) end -- SlidePositionOffset
  -- message_CloseEnforce
  -- GAP: se_Play(6927) — id SE NDS sans portage PMDO identifié
  GAME:FadeOut(true, 5) -- screen_WhiteOut
  -- GAP: SetEffect EFFECT_NONE sur PNJ non résolu (v2 cast SSA)
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(45)
  -- GAP: se_Play(7180) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- supervision_Acting(1) [neutre/état moteur]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english=" Stop!", french=" Il suffit!", german=" Stopp!", italian=" Fermatevi!", spanish=" ¡Alto!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:FadeIn(15)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(npc_npc_raiboruto, "shock", 1) end)
  local npc_npc_rakurai = SkySceneKit.spawn_npc("electrike", 208, 216, Direction.DownRight, "NPC_RAKURAI")
  pcall(function() GROUND:CharSetEmote(npc_npc_rakurai, "shock", 1) end)
  local npc_npc_rakurai2 = SkySceneKit.spawn_npc("electrike", 352, 216, Direction.DownLeft, "NPC_RAKURAI2")
  pcall(function() GROUND:CharSetEmote(npc_npc_rakurai2, "shock", 1) end)
  local npc_npc_rakurai3 = SkySceneKit.spawn_npc("electrike", 232, 184, Direction.DownRight, "NPC_RAKURAI3")
  pcall(function() GROUND:CharSetEmote(npc_npc_rakurai3, "shock", 1) end)
  local npc_npc_rakurai4 = SkySceneKit.spawn_npc("electrike", 328, 184, Direction.DownLeft, "NPC_RAKURAI4")
  pcall(function() GROUND:CharSetEmote(npc_npc_rakurai4, "shock", 1) end)
  local npc_npc_rakurai6 = SkySceneKit.spawn_npc("electrike", 304, 168, Direction.Down, "NPC_RAKURAI6")
  pcall(function() GROUND:CharSetEmote(npc_npc_rakurai6, "shock", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  local npc_npc_yonowaaru = SkySceneKit.spawn_npc("dusknoir", 280, 240, Direction.Up, "NPC_YONOWAARU")
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Stop this instant![K] Their words\nare sincere!", french="Cessez immédiatement![K] Ces\ndeux Pokémon sont sincères!", german="Sofort aufhören![K] Sie sagen die\nWahrheit!", italian="Basta così! Fermatevi![K] Le loro\nparole sono sincere!", spanish="¡Deteneos ahora mismo![K]\n¡Sus palabras son sinceras!"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="They trespass, but they don't\nintend to make claims on your territory!", french="Nul n'a l'intention de\ns'emparer de votre territoire!", german="Sie sind hier eingedrungen, aber\nsie wollen euch euer Revier nicht nehmen!", italian="È vero, questi Pokémon sono\nentrati nel vostro territorio, ma non\nintendevano mancarvi di rispetto!", spanish="¡Han entrado sin permiso, pero\nno pretenden apropiarse de vuestro territorio!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(hero, "exclaim", 1) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "exclaim", 1) end) end end
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" [CS:N]Dus[CR]...[K] [CS:N]Dusknoir[CR]!", french=" [CS:N]Noctu[CR]...[K] [CS:N]Noctunoir[CR]!", german=" [CS:N]Zwirr[CR]...[K] [CS:N]Zwirrfinst[CR]!", italian=" [CS:N]Dus[CR]...[K] [CS:N]Dusknoir[CR]!", spanish=" [CS:N]Dus[CR]...[K] ¡[CS:N]Dusknoir[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Dus[CR]...[K] [CS:N]Dusknoir[CR]!", french=" [CS:N]Noctu[CR]...[K] [CS:N]Noctunoir[CR]!", german=" [CS:N]Zwirr[CR]...[K] [CS:N]Zwirrfinst[CR]!", italian=" [CS:N]Dus[CR]...[K] [CS:N]Dusknoir[CR]!", spanish=" [CS:N]Dus[CR]...[K] ¡[CS:N]Dusknoir[CR]!"})
  else
  SkySceneKit.say({english=" [CS:N]Dus[CR]...[K] [CS:N]Dusknoir[CR]!", french=" [CS:N]Noctu[CR]...[K] [CS:N]Noctunoir[CR]!", german=" [CS:N]Zwirr[CR]...[K] [CS:N]Zwirrfinst[CR]!", italian=" [CS:N]Dus[CR]...[K] [CS:N]Dusknoir[CR]!", spanish=" [CS:N]Dus[CR]...[K] ¡[CS:N]Dusknoir[CR]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_raiboruto.Position; GROUND:MoveToPosition(npc_npc_raiboruto, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_rakurai.Position; GROUND:MoveToPosition(npc_npc_rakurai, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_rakurai2.Position; GROUND:MoveToPosition(npc_npc_rakurai2, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_rakurai3.Position; GROUND:MoveToPosition(npc_npc_rakurai3, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2)
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_rakurai4.Position; GROUND:MoveToPosition(npc_npc_rakurai4, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  local npc_npc_rakurai5 = SkySceneKit.spawn_npc("electrike", 256, 168, Direction.Down, "NPC_RAKURAI5")
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_rakurai5.Position; GROUND:MoveToPosition(npc_npc_rakurai5, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_rakurai6.Position; GROUND:MoveToPosition(npc_npc_rakurai6, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2)
  local npc_npc_rakurai7 = SkySceneKit.spawn_npc("electrike", 208, 168, Direction.DownRight, "NPC_RAKURAI7")
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_rakurai7.Position; GROUND:MoveToPosition(npc_npc_rakurai7, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  local npc_npc_rakurai8 = SkySceneKit.spawn_npc("electrike", 352, 168, Direction.DownLeft, "NPC_RAKURAI8")
  -- SetAnimation(5) [anim idle native]
  do local p=npc_npc_rakurai8.Position; GROUND:MoveToPosition(npc_npc_rakurai8, p.X+(0), p.Y+(-8), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_raiboruto) end)
  SkySceneKit.say({english=" You![K] Who are you?!", french=" Toi![K] Qui es-tu?!", german=" Du![K] Wer bist du?!?", italian=" E tu chi sei?", spanish=" ¡Tú![K] ¡¿Quién eres?!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" I am the explorer [CS:N]Dusknoir[CR]!", french=" Je suis [CS:N]Noctunoir[CR] l'explorateur!", german="Ich bin [CS:N]Zwirrfinst[CR],\nder Erkunder!", italian=" Il mio nome è [CS:N]Dusknoir[CR]!", spanish=" ¡Soy el explorador [CS:N]Dusknoir[CR]!"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="[CS:N]Manectric[CR]![K]\nYou have every right to be angry!", french="[CS:N]Elecsprint[CR]![K]\nTu as de bonnes raisons d'être en colère!", german="[CS:N]Voltenso[CR]![K]\nDu hast jedes Recht, so wütend zu sein!", italian="[CS:N]Manectric[CR]![K]\nHai tutto il diritto di essere arrabbiato!", spanish="¡[CS:N]Manectric[CR]![K] Tienes todo\nel derecho del mundo a enfadarte."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Especially in light of what your\ntribe has suffered on these grounds...", french="Surtout après ce que ton clan\na subi par le passé...", german="Vor allem, wenn man bedenkt,\nwelches Leid euer Stamm hier schon\nertragen musste...", italian="Conosco le terribili disgrazie che\nla vostra tribù ha dovuto attraversare...", spanish="Especialmente con todo lo que\nha sufrido tu tribu en este lugar..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Your hostility toward any that\ntrespass here is natural!", french="Ton hostilité envers les intrus\nest bien naturelle!", german="Eure Feindseligkeit gegenüber\njedem Eindringling ist nur natürlich!", italian="È naturale che vogliate\ndifendere quello che è vostro!", spanish="Tu hostilidad hacia cualquier\nintruso es natural."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="This place is your haven! A place\nwhere you find solace!", french="Ces lieux sont votre refuge!\nVotre havre de paix!", german="Dieser Ort ist eure Zuflucht!\nEin Ort, an dem ihr Trost findet!", italian=" Questo posto è la vostra casa!", spanish="Este lugar es vuestro santuario.\nUn lugar donde vivir tranquilos."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" I understand that completely!", french="Je ne vous comprends que\ntrop bien!", german=" Ich verstehe euch vollkommen!", italian="Noi rispettiamo il vostro\nterritorio!", spanish=" Lo entiendo perfectamente."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="On behalf of these unwitting\ntrespassers, I offer the sincerest apology!", french="Je vous présente mes excuses\nles plus sincères, au nom des intrus\ninconscients que nous sommes!", german="Im Namen dieser unwissenden\nEindringlinge bitte ich euch aufrichtig um\nVerzeihung!", italian="Ti prego di perdonare questi due\nignari Pokémon esploratori!", spanish="Os ofrezco mi más sincera\ndisculpa por esta involuntaria intrusión."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="They entered here unbidden, but\ndid so without malice! They mean no harm!", french="Ces deux-là ont pénétré ici\nsans permission, mais en toute innocence!\nNul mal ne vous sera fait!", german="Sie sind hier unerlaubterweise\neingedrungen, aber ohne schlechte Absicht!\nSie wollen euch nichts Böses!", italian="Hanno invaso la vostra casa, ma\nnon sono mossi da cattive intenzioni!", spanish="No deberían haber entrado aquí,\npero no sabían nada de vosotros. Ni tenían\nmala intención."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="We will leave you in peace as\nsoon as our errand is complete!", french="Nous partirons dès que\nnotre mission ici sera terminée!", german="Wir werden euch in Ruhe lassen,\nsobald wir gefunden haben, was wir suchen!", italian="Ce ne andremo e vi lasceremo in\npace appena avremo svolto il nostro compito.", spanish="Nos iremos en paz tras haber\ncompletado nuestra misión."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Please, believe me![K] [CS:N]Manectric[CR]!", french="Je te supplie de me croire![K]\n[CS:N]Elecsprint[CR]!", german=" Bitte glaube mir![K] [CS:N]Voltenso[CR]!", italian=" Ti prego, [CS:N]Manectric[CR]! [K]Credimi!", spanish=" ¡Debes creerme...![K] ¡[CS:N]Manectric[CR]!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_raiboruto) end)
  SkySceneKit.say({english="Hmm...[K] You seem to know much\nabout us, [CS:N]Dusknoir[CR].", french="Hum...[K] on dirait que tu en sais\nlong sur nous, [CS:N]Noctunoir[CR].", german="Hmm...[K] Du scheinst viel über uns\nzu wissen, [CS:N]Zwirrfinst[CR].", italian="Mmm...[K] Sembra che tu conosca\nbene la nostra storia, [CS:N]Dusknoir[CR].", spanish="Hum...[K] Pareces saber mucho\nde nosotros, [CS:N]Dusknoir[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_raiboruto) end)
  SkySceneKit.say({english="You make the claim...[K]that they\nmean no harm...", french="Tu affirmes...[K] qu'aucun mal\nne nous sera fait...", german="Du behauptest,[K] sie wollen\nuns nichts Böses...", italian="Tu affermi...[K] che questi due\nPokémon non hanno cattive intenzioni...", spanish="Según dices...[K] no tenían mala\nintención."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(npc_npc_raiboruto) end)
  SkySceneKit.say({english="So be it! I choose to believe\nyour words, [CS:N]Dusknoir[CR].", french="Soit! Je te fais confiance,\n[CS:N]Noctunoir[CR].", german="Also gut! Ich glaube dir,\n[CS:N]Zwirrfinst[CR].", italian=" E sia! Voglio crederti, [CS:N]Dusknoir[CR].", spanish="En fin, voy a creer tus palabras,\n[CS:N]Dusknoir[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_raiboruto) end)
  SkySceneKit.say({english="I will allow you some time.[K]\nI expect you to be gone by our return.", french="Je vais vous accorder un peu\nde temps.[K] Tâchez de ne plus être\nlà quand nous reviendrons.", german="Ihr sollt etwas Zeit haben.[K]\nIch erwarte, dass ihr verschwunden seid, wenn\nwir wieder zurück sind.", italian="Potrete restare, ma solo per\npoco.[K] Non voglio trovarvi qui al mio ritorno.", spanish="Os concederé un tiempo.[K]\nEspero que os hayáis marchado cuando vuelva."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_raiboruto, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_rakurai, npc_npc_raiboruto, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_rakurai2, npc_npc_raiboruto, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_rakurai3, npc_npc_raiboruto, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_rakurai4, npc_npc_raiboruto, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_rakurai5, npc_npc_raiboruto, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_rakurai6, npc_npc_raiboruto, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_rakurai7, npc_npc_raiboruto, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_rakurai8, npc_npc_raiboruto, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  GROUND:EntTurn(npc_npc_raiboruto, Direction.UpLeft)
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_raiboruto, Direction.UpRight)
  GAME:WaitFrames(45)
  GROUND:EntTurn(npc_npc_raiboruto, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  pcall(function() UI:SetSpeaker(npc_npc_raiboruto) end)
  SkySceneKit.say({english=" Come.", french=" Partons.", german=" Kommt.", italian=" Andiamo.", spanish=" Vámonos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_raiboruto.Position; GROUND:MoveToPosition(npc_npc_raiboruto, p.X+(0), p.Y+(-180), false, 2) end
  GROUND:EntTurn(npc_npc_rakurai, Direction.UpRight)
  GROUND:EntTurn(npc_npc_rakurai2, Direction.UpLeft)
  GAME:WaitFrames(10)
  GROUND:EntTurn(npc_npc_rakurai3, Direction.UpRight)
  GROUND:EntTurn(npc_npc_rakurai4, Direction.UpLeft)
  GAME:WaitFrames(5)
  GROUND:EntTurn(npc_npc_rakurai5, Direction.UpRight)
  GROUND:EntTurn(npc_npc_rakurai6, Direction.Up)
  GROUND:EntTurn(npc_npc_rakurai7, Direction.Up)
  GROUND:EntTurn(npc_npc_rakurai8, Direction.UpLeft)
  GAME:WaitFrames(30)
  do local p=npc_npc_rakurai7.Position; GROUND:MoveToPosition(npc_npc_rakurai7, p.X+(0), p.Y+(-180), false, 2) end
  do local p=npc_npc_rakurai6.Position; GROUND:MoveToPosition(npc_npc_rakurai6, p.X+(0), p.Y+(-180), false, 2) end
  do local p=npc_npc_rakurai5.Position; GROUND:MoveToPosition(npc_npc_rakurai5, p.X+(0), p.Y+(-180), false, 2) end
  do local p=npc_npc_rakurai8.Position; GROUND:MoveToPosition(npc_npc_rakurai8, p.X+(0), p.Y+(-180), false, 2) end
  GAME:WaitFrames(15)
  do local p=npc_npc_rakurai3.Position; GROUND:MoveToPosition(npc_npc_rakurai3, p.X+(0), p.Y+(-180), false, 2) end
  do local p=npc_npc_rakurai4.Position; GROUND:MoveToPosition(npc_npc_rakurai4, p.X+(0), p.Y+(-180), false, 2) end
  GAME:WaitFrames(10)
  do local p=npc_npc_rakurai.Position; GROUND:MoveToPosition(npc_npc_rakurai, p.X+(0), p.Y+(-180), false, 2) end
  do local p=npc_npc_rakurai2.Position; GROUND:MoveToPosition(npc_npc_rakurai2, p.X+(0), p.Y+(-180), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused_2") end)
  pcall(function() GROUND:CharSetEmote(partner, "sweatdrop", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Whew!", french=" Ouf!", german=" Puh!", italian=" Fiuu!", spanish=" ¡Menos mal!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Whew!", french=" Ouf!", german=" Puh!", italian=" Fiuu!", spanish=" ¡Menos mal!"})
  else
  SkySceneKit.say({english=" Whew!", french=" Ouf!", german=" Puh!", italian=" Fiuu!", spanish=" ¡Menos mal!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Thank you, [CS:N]Dusknoir[CR], sir!", french=" Merci, messire [CS:N]Noctunoir[CR]!", german=" Vielen Dank, [CS:N]Zwirrfinst[CR]!", italian=" Grazie, signor [CS:N]Dusknoir[CR]!", spanish=" ¡Gracias, [CS:N]Dusknoir[CR]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Thank you, [CS:N]Dusknoir[CR], sir!", french=" Merci, messire [CS:N]Noctunoir[CR]!", german=" Vielen Dank, [CS:N]Zwirrfinst[CR]!", italian=" Grazie, signor [CS:N]Dusknoir[CR]!", spanish=" ¡Gracias, [CS:N]Dusknoir[CR]!"})
  else
  SkySceneKit.say({english=" Thank you, [CS:N]Dusknoir[CR], sir!", french=" Merci, messire [CS:N]Noctunoir[CR]!", german=" Vielen Dank, [CS:N]Zwirrfinst[CR]!", italian=" Grazie, signor [CS:N]Dusknoir[CR]!", spanish=" ¡Gracias, [CS:N]Dusknoir[CR]!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" You saved us!", french=" Vous êtes notre sauveur!", german=" Du hast uns gerettet!", italian=" Ci ha salvato!", spanish=" ¡Nos has salvado!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" You saved us!", french=" Vous êtes notre sauveur!", german=" Du hast uns gerettet!", italian=" Ci ha salvato!", spanish=" ¡Nos has salvado!"})
  else
  SkySceneKit.say({english=" You saved us!", french=" Vous êtes notre sauveur!", german=" Du hast uns gerettet!", italian=" Ci ha salvato!", spanish=" ¡Nos has salvado!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But...", french=" Mais...", german=" Aber...", italian=" Ma...", spanish=" Pero..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But...", french=" Mais...", german=" Aber...", italian=" Ma...", spanish=" Pero..."})
  else
  SkySceneKit.say({english=" But...", french=" Mais...", german=" Aber...", italian=" Ma...", spanish=" Pero..."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Who were they?", french=" Qui c'était?", german=" Wer war das?", italian=" Chi erano quelli?", spanish=" ¿Quiénes eran?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Who were they?", french=" Qui c'était?", german=" Wer war das?", italian=" Chi erano quelli?", spanish=" ¿Quiénes eran?"})
  else
  SkySceneKit.say({english=" Who were they?", french=" Qui c'était?", german=" Wer war das?", italian=" Chi erano quelli?", spanish=" ¿Quiénes eran?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="A group of [CS:N]Manectric[CR] and\n[CS:N]Electrike[CR].", french="Une tribu d'[CS:N]Elecsprint[CR]\net de [CS:N]Dynavolt[CR].", german="Eine Gruppe aus [CS:N]Voltenso[CR] und\n[CS:N]Frizelbliz[CR].", italian="Un gruppo di [CS:N]Manectric[CR] e\n[CS:N]Electrike[CR].", spanish="Un grupo de [CS:N]Manectric[CR] y\n[CS:N]Electrike[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="They are a nomadic tribe that\nalways stays on the move.", french=" Il s'agit d'une tribu nomade.", german="Sie sind ein Nomadenstamm, der\nständig auf Wanderschaft ist.", italian="Si tratta di una tribù nomade,\nsempre in movimento.", spanish=" Son una tribu nómada."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="They roam in constant search of\nplaces that are hospitable to them.", french="Ils errent sans cesse en quête\nde terres hospitalières.", german="Sie ziehen umher auf der Suche\nnach Orten, an denen sie eine Weile bleiben\nkönnen.", italian="Si spostano alla continua\nricerca di un posto che gli sia congeniale.", spanish="Van de aquí para allá, buscando\nsitios donde sentirse a gusto."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="And [CS:P]Amp Plains[CR] is often lashed\nby thunderstorms this time of year.", french="A cette époque de l'année,\nde fréquents orages s'abattent sur les [CS:P]Plaines\nElek[CR].", german="Und die [CS:P]Ampere-Ebene[CR] wird um\ndiese Jahreszeit oft von Gewittern\nheimgesucht.", italian="In questo periodo dell'anno, le\n[CS:P]Pianure Saetta[CR] attraggono molte tempeste e\nmolti fulmini.", spanish="En esta época del año las\ntormentas azotan la [CS:P]Pradera Destello[CR]."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="They find it to their liking, so\nthey dwell in [CS:P]Amp Plains[CR] this time of year.", french="Comme ces conditions leur\nconviennent parfaitement, ils s'installent dans\nles [CS:P]Plaines Elek[CR] pour la saison.", german="Hier fühlen sie sich wohl, also\nhalten sie sich um diese Jahreszeit in der\n[CS:P]Ampere-Ebene[CR] auf.", italian="Questo è il clima perfetto per\nloro, così, in questa stagione, fanno delle\n[CS:P]Pianure Saetta[CR] la loro dimora.", spanish="Eso les agrada, así que suelen\npasar aquí, en la [CS:P]Pradera Destello[CR],\nuna temporada."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="But, tragically, they were once\nattacked by enemies here without warning...", french="Mais, hélas, un jour des ennemis\ns'en prirent à eux sans crier gare...", german="Doch tragischerweise wurden sie\nhier einst überraschend von Feinden\nangegriffen...", italian="Molti anni fa, quando si\ntrovavano da queste parti, furono presi di\nsorpresa da un'imboscata...", spanish="Pero lo triste es que, una vez,\nfueron atacados sin previo aviso en esta\nzona..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="And I understand that they\nsuffered terrible injuries.", french="Et, d'après mes sources, ils ont\nété très grièvement blessés.", german="Und ich weiß, dass sie sehr\ngroße Verluste erleiden mussten.", italian=" Soffrirono terribili perdite.", spanish="Se ve que sufrieron heridas\nterribles."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Ever since, [CS:N]Manectric[CR]'s group\nhas been very sensitive about\ntrespassers here.", french="Depuis, la tribu d'[CS:N]Elecsprint[CR]\nétait devenue très sensible à la présence\nd'intrus sur son territoire.", german="Seitdem reagiert die Gruppe um\n[CS:N]Voltenso[CR] sehr empfindlich\nauf Eindringlinge.", italian="Da allora, il gruppo di [CS:N]Manectric[CR]\nnon vede di buon occhio chi si introduce\nqui dentro senza permesso.", spanish="Desde entonces, el grupo de\n[CS:N]Manectric[CR] está muy susceptible con\nel tema de los intrusos."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="So if anyone trespassed upon\nthese grounds, well...[K]they would strike first,\nfor fear of being stricken!", french="Ainsi, dès que quelqu'un faisait\nintrusion ici...[K] ils attaquaient les premiers,\nde peur qu'on ne les attaque!", german="Wenn also jemand in dieses\nGebiet eindringt,[K] dann greifen sie sofort an,\naus Angst, selbst angegriffen zu werden!", italian="Chiunque osi invadere il loro\nterritorio...[K] viene attaccato all'istante!", spanish="Si se encontraban a cualquier\nintruso...[K] ¡preferían atacar primero para\nevitar ser atacados!"})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Somehow, at some point...[K]\nThat became a law among [CS:N]Manectric[CR]'s group.", french="Un jour, sans qu'on ne sache trop\ncomment...[K] c'est devenu une coutume dans\nla tribu d'[CS:N]Elecsprint[CR].", german="An einem Punkt wurde es wohl...[K]\nzu einer Art Gesetz in der Gruppe um [CS:N]Voltenso[CR].", italian="Nel corso del tempo...[K]\nquesta è diventata la legge del gruppo\ndi [CS:N]Manectric[CR].", spanish="En algún momento...[K]\nSe convirtió en una ley del grupo de [CS:N]Manectric[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Oh, I get it now. That's why they\ncame after us.", french="Ah, maintenant je comprends\npourquoi ils s'en sont pris à nous.", german="Oh, jetzt verstehe ich. Darum\nhatten sie es auf uns abgesehen.", italian="Ah! Adesso ho capito! Ecco\nperché ce l'avevano con noi!", spanish="¡Ahora lo pillo!\nPor eso creían que éramos una amenaza."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Oh, I understand now. That's why\nthey were so intent on attacking.", french="Ah, maintenant je comprends\npourquoi ils s'en sont pris à nous.", german="Oh, jetzt verstehe ich. Darum\nwaren sie so angriffslustig.", italian="Adesso capisco. È per questo che\nci hanno attaccato.", spanish="¡Ahora lo entiendo!\nPor eso querían atacarnos."})
  else
  SkySceneKit.say({english="Oh, I get it now. That's why they\nwanted to fight us.", french="Ah, maintenant je comprends\npourquoi ils s'en sont pris à nous.", german="Oh, jetzt verstehe ich. Darum\nwollten sie gegen uns kämpfen.", italian="Adesso capisco. È per questo che\nci hanno attaccato.", spanish="¡Ahora lo entiendo!\nPor eso querían atacarnos."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="No wonder they wouldn't listen\nto any of our arguments.", french="Pas étonnant qu'ils aient refusé\nde nous écouter.", german="Kein Wunder, dass sie uns\nnicht geglaubt haben.", italian="Non mi sorprende che non\nabbiano voluto ascoltarci.", spanish="No me extraña que no quisieran\nentrar en razón."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="It's no wonder they refused to\nhear our arguments.", french="Pas étonnant qu'ils aient refusé\nde nous écouter.", german="Kein Wunder, dass sie uns\nnicht zuhören wollten.", italian="Non mi sorprende che non\nabbiano voluto ascoltarci.", spanish="No me extraña que no quisieran\nentrar en razón."})
  else
  SkySceneKit.say({english="No wonder they refused to hear\nour arguments.", french="Pas étonnant qu'ils aient refusé\nde nous écouter.", german="Kein Wunder, dass sie uns\nnicht zuhören wollten.", italian="Non mi sorprende che non\nabbiano voluto ascoltarci.", spanish="No me extraña que no quisieran\nentrar en razón."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Startled") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Oh! I forgot something!", french=" Oh, j'ai failli oublier!", german=" Oh! Ich habe etwas vergessen!", italian=" Oh! Quasi dimenticavo!", spanish=" ¡Vaya! Se me olvidaba."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Oh! I forgot something!", french=" Oh, j'ai failli oublier!", german=" Oh! Ich habe etwas vergessen!", italian=" Oh! Quasi dimenticavo!", spanish=" ¡Vaya! Se me olvidaba."})
  else
  SkySceneKit.say({english=" Oh! I forgot something!", french=" Oh, j'ai failli oublier!", german=" Oh! Ich habe etwas vergessen!", italian=" Oh! Quasi dimenticavo!", spanish=" ¡Vaya! Se me olvidaba."})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I think the [CS:Z]Water Float[CR] was\nover there...", french="Il me semble avoir vu\nl'[CS:Z]Hydroflotteur[CR] par là...", german="Ich glaube, der [CS:Z]Schwimmreif[CR]\nwar dort drüben.", italian="L'[CS:Z]Acquaboa[CR] è da queste parti,\nse non sbaglio...", spanish=" Creo que el [CS:Z]Flotarill[CR] estaba allí..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="I recall seeing the [CS:Z]Water Float[CR]\nover there...", french="Il me semble avoir vu\nl'[CS:Z]Hydroflotteur[CR] par là...", german="Ich habe vorhin dort drüben\nden [CS:Z]Schwimmreif[CR] gesehen.", italian="L'[CS:Z]Acquaboa[CR] è da queste parti,\nse non sbaglio...", spanish="Recuerdo haber visto el [CS:Z]Flotarill[CR]\npor allí..."})
  else
  SkySceneKit.say({english="I thought I saw the [CS:Z]Water Float[CR]\nover there...", french="Il me semble avoir vu\nl'[CS:Z]Hydroflotteur[CR] par là...", german="Ich dachte, ich hätte da drüben\nden [CS:Z]Schwimmreif[CR] gesehen.", italian="L'[CS:Z]Acquaboa[CR] è da queste parti,\nse non sbaglio...", spanish="Creo que el [CS:Z]Flotarill[CR]\nestaba allí..."})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GAME:MoveCamera(276, 140, 60, false) end) -- performer/caméra
  GROUND:MoveToPosition(partner, 252, 132, false, 2)
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Up)
  GAME:WaitFrames(10)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(-40), false, 2) end
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:MoveToPosition(__slot, 228, 172, false, 2) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:MoveToPosition(__slot, 204, 156, false, 2) end end
  GAME:WaitFrames(30)
  GROUND:MoveToPosition(npc_npc_yonowaaru, 276, 156, false, 2)
  GROUND:MoveToPosition(hero, 300, 132, false, 2)
  GROUND:EntTurn(partner, Direction.UpRight)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.UpRight) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.UpRight) end end
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's here! Here it is!", french=" Il est là! Il est là!", german=" Er ist hier! Das ist er!", italian=" Eccola! L'ho trovata!", spanish=" ¡Por fin! ¡Aquí está!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It's here! This is it!", french=" Il est là! Il est là!", german=" Er ist hier! Das ist er!", italian=" Eccola! L'ho trovata!", spanish=" ¡Por fin! ¡Aquí está!"})
  else
  SkySceneKit.say({english=" It's here! This is it!", french=" Il est là! Il est là!", german=" Er ist hier! Das ist er!", italian=" Eccola! L'ho trovata!", spanish=" ¡Por fin! ¡Aquí está!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, npc_npc_yonowaaru, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="[CS:N]Dusknoir[CR], sir, can you take a\nlook at this?", french="Messire [CS:N]Noctunoir[CR], pouvez-vous\ny jeter un coup d'œil?", german="[CS:N]Zwirrfinst[CR], kannst du dir\ndas ansehen?", italian="Signor [CS:N]Dusknoir[CR], può dirci se è\nquesta?", spanish=" [CS:N]Dusknoir[CR], ¿puedes mirar esto?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" [CS:N]Dusknoir[CR], sir, is this the...?", french="Messire [CS:N]Noctunoir[CR], pouvez-vous\ny jeter un coup d'œil?", german=" [CS:N]Zwirrfinst[CR], ist das der...", italian="Signor [CS:N]Dusknoir[CR], può dirci se è\nquesta?", spanish=" [CS:N]Dusknoir[CR], ¿puedes mirar esto?"})
  else
  SkySceneKit.say({english=" [CS:N]Dusknoir[CR], sir, is this...?", french="Messire [CS:N]Noctunoir[CR], pouvez-vous\ny jeter un coup d'œil?", german=" [CS:N]Zwirrfinst[CR], ist das der...", italian="Signor [CS:N]Dusknoir[CR], può dirci se è\nquesta?", spanish=" [CS:N]Dusknoir[CR], ¿puedes mirar esto?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="There's no mistaking it. Without\na doubt, this is a [CS:Z]Water Float[CR].", french="Impossible de s'y tromper.\nCeci est un [CS:Z]Hydroflotteur[CR], à n'en pas douter.", german="Es besteht kein Zweifel.\nDas ist mit Sicherheit der [CS:Z]Schwimmreif[CR].", italian="Ma certamente. Si tratta\nsenz'altro di un'[CS:Z]Acquaboa[CR].", spanish="No hay ninguna duda.\nEsto es un [CS:Z]Flotarill[CR]."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(hero, npc_npc_yonowaaru, 4) end)
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Really?!", french=" Vraiment?!", german=" Wirklich?!?", italian=" Davvero?", spanish=" ¡¿En serio?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Really?!", french=" Vraiment?!", german=" Wirklich?!?", italian=" Davvero?", spanish=" ¡¿En serio?!"})
  else
  SkySceneKit.say({english=" Really?!", french=" Vraiment?!", german=" Wirklich?!?", italian=" Davvero?", spanish=" ¡¿En serio?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="We did it! Let's return the item\nto [CS:N]Marill[CR] and his little brother!", french="On l'a trouvé! Allons le rendre à\n[CS:N]Marill[CR] et à son petit frère!", german="Wir haben es geschafft! Bringen\nwir das Item zurück zu [CS:N]Marill[CR] und seinem\nkleinen Bruder!", italian="Evvai! Ce l'abbiamo fatta! E ora\nandiamo a riportarla a [CS:N]Marill[CR] e al suo\nfratellino!", spanish="¡Lo hemos conseguido! ¡Vamos a\ndevolvérselo a [CS:N]Marill[CR] y a su hermano!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="We did it! Let's return the item\nto [CS:N]Marill[CR] and his little brother right away!", french="On l'a trouvé! Allons le rendre à\n[CS:N]Marill[CR] et à son petit frère!", german="Wir haben es geschafft! Bringen\nwir das Item sofort zurück zu [CS:N]Marill[CR] und\nseinem kleinen Bruder!", italian="Evviva! Ce l'abbiamo fatta!\nAndiamo a restituirla a [CS:N]Marill[CR] e al suo\nfratellino!", spanish="¡Lo hemos conseguido! ¡Vamos a\ndevolvérselo a [CS:N]Marill[CR] y a su hermano!"})
  else
  SkySceneKit.say({english="We did it! Let's return the item\nto [CS:N]Marill[CR] and his little brother right away!", french="On l'a trouvé! Allons le rendre à\n[CS:N]Marill[CR] et à son petit frère!", german="Wir haben es geschafft! Bringen\nwir das Item sofort zurück zu [CS:N]Marill[CR] und\nseinem kleinen Bruder!", italian="Evviva! Ce l'abbiamo fatta!\nAndiamo a restituirla a [CS:N]Marill[CR] e al suo\nfratellino!", spanish="¡Lo hemos conseguido! ¡Vamos a\ndevolvérselo a [CS:N]Marill[CR] y a su hermano!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(partner, Direction.UpRight)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Confused") end)
  pcall(function() GROUND:CharSetEmote(partner, "question", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="I wonder how this [CS:Z]Water Float[CR]\nwound up here?", french="Je me demande comment\ncet [CS:Z]Hydroflotteur[CR] est arrivé là.", german="Ich frage mich, wie der\n[CS:Z]Schwimmreif[CR] hier gelandet ist.", italian="Mi chiedo come abbia fatto\nquest'[CS:Z]Acquaboa[CR] ad arrivare fin qui...", spanish="Me pregunto cómo habrá\nacabado aquí este [CS:Z]Flotarill[CR]."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="There's something I don't\nunderstand, though. How did this [CS:Z]Water Float[CR]\nend up here?", french="Je me demande comment\ncet [CS:Z]Hydroflotteur[CR] est arrivé là.", german="Etwas verstehe ich aber nicht.\nWie ist der [CS:Z]Schwimmreif[CR] hier gelandet?", italian="Ma c'è una cosa che non capisco.\nCome ha fatto quest'[CS:Z]Acquaboa[CR] a finire qui?", spanish="Hay algo que no entiendo.\n¿Cómo ha acabado aquí este [CS:Z]Flotarill[CR]?"})
  else
  SkySceneKit.say({english="I don't get it, though...[K] How did\nthis [CS:Z]Water Float[CR] end up here?", french="Je me demande comment\ncet [CS:Z]Hydroflotteur[CR] est arrivé là.", german="Ich verstehe es trotzdem\nnicht...[K] Wie ist der [CS:Z]Schwimmreif[CR] hier\ngelandet?", italian="Ma c'è una cosa che non\ncapisco.[K] Come ha fatto quest'[CS:Z]Acquaboa[CR]\na finire qui?", spanish="Hay algo que no entiendo.[K]\n¿Cómo ha llegado aquí este [CS:Z]Flotarill[CR]?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I would imagine that it was\nput there deliberately.", french="J'imagine que quelqu'un\nl'a déposé ici délibérément.", german="Ich kann mir vorstellen, dass ihn\njemand absichtlich hergebracht hat.", italian="Chiunque l'abbia messa qui, lo ha\nfatto per una ragione ben precisa.", spanish="Me imagino que lo han puesto\naquí a propósito."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Whoever did this knew that you\nwould eventually get to this spot.", french="Qui qu'ils fussent, ils savaient\nque vous viendriez ici.", german="Dieser Jemand wusste, dass ihr\nletztendlich an diesen Ort kommen würdet.", italian="Il colpevole voleva che voi\narrivaste esattamente in questo posto.", spanish="Quien lo haya hecho sabía que\nacabaríamos llegando a este punto."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="The fact that [CS:N]Manectric[CR] protects\nits territory is well known...", french="Il est bien connu qu'[CS:N]Elecsprint[CR]\nprotège son territoire...", german="Die Tatsache, dass [CS:N]Voltenso[CR]\nihr Gebiet verteidigen, ist wohlbekannt...", italian="Tutti sanno che [CS:N]Manectric[CR]\ndifende strenuamente il proprio territorio...", spanish="Es un hecho conocido que\n[CS:N]Manectric[CR] protege su territorio..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Someone expected a\nconfrontation between you and [CS:N]Manectric[CR]...[K]\nYou were set up.", french="Quelqu'un cherchait à vous faire\naffronter [CS:N]Elecsprint[CR]...[K]\nVous vous êtes fait piéger.", german="Jemand hat den Angriff von\n[CS:N]Voltenso[CR] auf euch vorausgesehen...[K]\nDas war ein abgekartetes Spiel.", italian="Qualcuno voleva che\nvi scontraste con [CS:N]Manectric[CR]...[K]\nSiete stati incastrati.", spanish="Alguien esperaba que hubiera\nun enfrentamiento entre [CS:N]Manectric[CR]\ny vuestro equipo...[K] Era una trampa."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(60) end)
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Wasn't that your intention...[K]\nyou sneaking scoundrels?!", french="N'était-ce pas là ce que\nvous mijotiez...[K] infâmes scélérats?!", german="War das nicht eure Absicht?[K]\nIhr hinterlistiges Pack?!?", italian="Non è forse così...[K]\nfarabutti?!", spanish="¿Me equivoco?[K] ¿No era esa\nvuestra intención, sinvergüenzas de medio\npelo?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(hero, Direction.Down)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.DownRight) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.DownRight) end end
  GROUND:EntTurn(partner, Direction.Down)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(0, 1) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Huh?", french=" Quoi?", german=" Äh?", italian=" Eh?", spanish=" ¿Eh?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What?", french=" Quoi?", german=" Was?", italian=" Cosa?", spanish=" ¿Qué?"})
  else
  SkySceneKit.say({english=" Pardon?", french=" Quoi?", german=" Wie bitte?", italian=" Cosa?", spanish=" ¿Cómo?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="It's about time that you came out\nof hiding and showed yourselves!", french="Il est temps que vous sortiez\nde votre cachette pour vous montrer!", german="Es wird Zeit, dass ihr aus\neurem Versteck herauskommt und euch zeigt!", italian="È ora che diate un taglio a\nquesta ridicola sceneggiata!", spanish="¡Ya es hora de que salgáis\nde vuestro escondrijo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" ........................", french=" ........................", german=" ........................", italian=" ........................", spanish=" ..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="Chaw-haw-haw! So you knew all along![K]\nNo point in hiding, then!", french="Gnark gnark gnark! Donc tu le savais\ndepuis le début?[K] Inutile qu'on se cache,\nà ce moment-là!", german="Cha-ha-ha! Du hast es also die ganze Zeit\ngewusst![K] Dann müssen wir uns ja nicht mehr\nverstecken!", italian=" Ahr-ahr-ahr! Avevi capito tutto, eh?", spanish="¡Jua, jua, jua! ¡Así que lo supiste desde\nel principio![K] ¡No hay por qué esconderse\nentonces!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- supervision_Acting(2) [neutre/état moteur]
  GAME:WaitFrames(1)
  pcall(function() GAME:MoveCamera(276, 196, 60, false) end) -- performer/caméra
  local npc_npc_sukatanku = SkySceneKit.spawn_npc("skuntank", 320, 272, Direction.Up, "NPC_SUKATANKU")
  GROUND:MoveToPosition(npc_npc_sukatanku, 276, 236, false, 2)
  GAME:WaitFrames(15)
  local npc_npc_zubatto = SkySceneKit.spawn_npc("zubat", 320, 288, Direction.Up, "NPC_ZUBATTO")
  GROUND:MoveToPosition(npc_npc_zubatto, 276, 236, false, 2)
  GAME:WaitFrames(10)
  local npc_npc_dogaasu = SkySceneKit.spawn_npc("koffing", 336, 288, Direction.Up, "NPC_DOGAASU")
  GROUND:MoveToPosition(npc_npc_dogaasu, 276, 236, false, 2)
  GROUND:MoveToPosition(npc_npc_sukatanku, 276, 200, false, 2)
  GROUND:MoveToPosition(npc_npc_zubatto, 252, 216, false, 2)
  GROUND:MoveToPosition(npc_npc_dogaasu, 300, 216, false, 2)
  GROUND:EntTurn(npc_npc_sukatanku, Direction.Up)
  GROUND:EntTurn(npc_npc_zubatto, Direction.Up)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecutePerformer
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim") end)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  do local __slot = SkySceneKit.team_member(1); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then pcall(function() GROUND:CharSetEmote(__slot, "shock", 1) end) end end
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitSe
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Hey! It's you thugs!?", french="Eh, c'est vous, espèces\nde crapules!?", german=" Hey! Ihr Gauner wart das?!?", italian=" Ehi! Sono quei furfanti!", spanish=" ¡Eh! ¡¿Esos canallas?!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Hey! It's you thugs!?", french="Eh, c'est vous, espèces\nde crapules!?", german=" Hey! Ihr Gauner wart das?!?", italian=" Ehi! Sono quei mascalzoni!", spanish=" ¡Eh! ¡¿Esos canallas?!"})
  else
  SkySceneKit.say({english=" Hey! It's you thugs!?", french="Eh, c'est vous, espèces\nde crapules!?", german=" Hey! Ihr Gauner wart das?!?", italian=" Ehi! Sono quei mascalzoni!", spanish=" ¡Eh! ¡¿Esos canallas?!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBGM("Team Skull.ogg", true) end)
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english=" Whoa-ho-ho!", french=" Mouarf mouarf mouarf!", german=" Whoahoho!", italian=" Uooh-oh-oh!", spanish=" ¡Jo, jo, jo!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english=" Heh-heh-heh!", french=" Hin hin hin!", german=" Hehehe!", italian=" Eh-eh-eh!", spanish=" ¡Jue, jue, jue!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" Chaw-haw-haw!", french=" Gnark gnark gnark!", german=" Cha-ha-ha!", italian=" Ahr-ahr-ahr!", spanish=" ¡Jua, jua, jua!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" So you guys did it! But why?", french="Alors c'est vous qui avez fait\nça! On peut savoir pourquoi?", german=" Also wart ihr es! Aber warum?", italian="C'eravate voi dietro a tutto\nquesto, allora!", spanish="¡Así que fuisteis vosotros!\n¿Pero por qué?"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" So you guys did it! But why?", french="Alors c'est vous qui avez fait\nça! On peut savoir pourquoi?", german=" Also wart ihr es! Aber warum?", italian="C'eravate voi dietro a tutto\nquesto, allora!", spanish="¡Así que fuisteis vosotros!\n¿Pero por qué?"})
  else
  SkySceneKit.say({english=" So you guys did it! But why?", french="Alors c'est vous qui avez fait\nça! On peut savoir pourquoi?", german=" Also wart ihr es! Aber warum?", italian="C'eravate voi dietro a tutto\nquesto, allora!", spanish="¡Así que fuisteis vosotros!\n¿Pero por qué?"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="Whoa-ho-ho![K] We were going to\nwait for you to get stomped by [CS:N]Manectric[CR]...", french="Mouarf mouarf mouarf![K]\nOn avait l'intention d'attendre gentiment\nqu'[CS:N]Elecsprint[CR] vous piétine...", german="Whoahoho![K] Wir haben darauf\ngewartet, dass ihr von [CS:N]Voltenso[CR]\nzerstampft werdet...", italian="Uooh-ho-ho!![K] Pensavamo che\n[CS:N]Manectric[CR] vi avrebbe conciato per le feste...", spanish="¡Jo, jo, jo![K] Esperábamos que\n[CS:N]Manectric[CR] os pisoteara..."})
  pcall(function() UI:SetSpeaker(npc_npc_dogaasu) end)
  SkySceneKit.say({english="Then we were going to step in\nand mop up afterward!", french="On attendait juste qu'ils en aient\nfini avec vous pour ramasser les restes!", german="Danach wollten wir übernehmen\nund euch den Rest geben!", italian="Sarebbe stato molto più semplice\ncosì!", spanish="Para luego pasar nosotros a\nrecoger los restos."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_zubatto) end)
  SkySceneKit.say({english="Heh-heh! But we didn't count on\nthis guy meddling!", french="Hin hin! Mais on n'avait pas\nprévu qu'il vienne s'en mêler, celui-là!", german="Hehehe! Aber wir haben nicht\ngedacht, dass dieser Typ sich einmischt!", italian="Eh-eh! Ma non potevamo\nimmaginare che quel tizio si impicciasse...", spanish="¡Jue, jue! ¡Pero no esperábamos\nque este tipo se entrometiera!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_yonowaaru.Position; GROUND:MoveToPosition(npc_npc_yonowaaru, p.X+(0), p.Y+(8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english=" Shall we settle this?", french="Réglons cela si vous le voulez\nbien! En garde!", german=" Sollen wir die Sache erledigen?", italian="Vogliamo porre fine a questa\ncosa?", spanish=" ¿Queréis luchar?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="Chaw-haw! Sure, if it was just\nTeam [team:]. You can bet that we'd\nrough 'em up good!", french="Gnark gnark! Bien sûr, s'il n'y\navait eu que les deux de l'Equipe [team:],\non s'en serait débarrassés sans problème!", german="Cha-ha! Sicher, wenn es nur\nTeam [team:] wäre. Mit denen werden\nwir problemlos fertig!", italian="Ahr-ahr! Beh, se si trattasse di\naffrontare solo quelle schiappe del Team\n[team:], allora sì che ci divertiremmo!", spanish="¡Jua, jua! Claro, si solo se\ntratase del [CS:X]Equipo[CR] [team:]. ¡Les íbamos\na dar candela!"})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="But against the world-famous\n[CS:N]Dusknoir[CR]...?", french="Mais s'attaquer à l'illustre\n[CS:N]Noctunoir[CR]...?", german="Aber gegen den weltberühmten\n[CS:N]Zwirrfinst[CR]?", italian="Ma combattere contro il famoso\n[CS:N]Dusknoir[CR]...?", spanish="Pero, ¿contra el famosísimo\n[CS:N]Dusknoir[CR]...?"})
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" That's a different story!", french=" C'est une autre histoire!", german=" Das ist eine andere Geschichte!", italian=" Abbiamo solo da perderci!", spanish=" ¡Eso es otra historia!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  do local p=npc_npc_yonowaaru.Position; GROUND:MoveToPosition(npc_npc_yonowaaru, p.X+(0), p.Y+(8), false, 1) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() SOUND:FadeOutBGM(10) end)
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english=" Let's skedaddle, boys!", french=" Allez, les gars, on s'arrache!", german="Machen wir uns aus dem Staub,\nJungs!", italian=" Squagliamocela, ragazzi!", spanish=" ¡Salgamos pitando, chicos!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:SetSpeaker(npc_npc_sukatanku) end)
  SkySceneKit.say({english="[CS:N]Koffing[CR] & [CS:N]Zubat[CR]: Yeah!", french="[CS:N]Smogo[CR] et [CS:N]Nosferapti[CR]: Et comment!", german="[CS:N]Smogon[CR] und [CS:N]Zubat[CR]: Ja!", italian="[CS:N]Koffing[CR] e [CS:N]Zubat[CR]: Ricevuto!", spanish="[CS:N]Koffing[CR] y [CS:N]Zubat[CR]: ¡Hasta luego!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(7430) — id SE NDS sans portage PMDO identifié
  do local p=npc_npc_sukatanku.Position; GROUND:MoveToPosition(npc_npc_sukatanku, p.X+(0), p.Y+(180), false, 2) end
  GROUND:EntTurn(npc_npc_zubatto, Direction.Down)
  GROUND:EntTurn(npc_npc_dogaasu, Direction.Down)
  GAME:WaitFrames(10)
  do local p=npc_npc_zubatto.Position; GROUND:MoveToPosition(npc_npc_zubatto, p.X+(0), p.Y+(180), false, 2) end
  GAME:WaitFrames(5)
  do local p=npc_npc_dogaasu.Position; GROUND:MoveToPosition(npc_npc_dogaasu, p.X+(-16), p.Y+(180), false, 2) end
  GAME:WaitFrames(10)
  do local p=partner.Position; GROUND:MoveToPosition(partner, p.X+(0), p.Y+(24), false, 2) end
  GAME:WaitFrames(10)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(0), p.Y+(24), false, 2) end
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- message_FacePositionOffset(-3, 0) [neutre/état moteur]
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" What stinkers!", french=" Quelle bande de vauriens!", german=" Widerlinge!", italian=" Che farabutti!", spanish=" ¡Qué apestosos!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" What stinkers!", french=" Quelle bande de vauriens!", german=" Widerlinge!", italian=" Che farabutti!", spanish=" ¡Qué apestosos!"})
  else
  SkySceneKit.say({english=" What stinkers!", french=" Quelle bande de vauriens!", german=" Widerlinge!", italian=" Che farabutti!", spanish=" ¡Qué apestosos!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" I'm never forgiving those thugs!", french=" Je ne leur pardonnerai jamais!", german="Das vergesse ich diesen\nHalunken nie!", italian=" Come hanno potuto!", spanish="¡Nunca perdonaré a esos\ncanallas!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" I'm never forgiving those thugs!", french=" Je ne leur pardonnerai jamais!", german="Das vergesse ich diesen\nHalunken nie!", italian=" Come hanno potuto!", spanish="¡Nunca perdonaré a esos\ncanallas!"})
  else
  SkySceneKit.say({english=" I'm never forgiving those guys!", french=" Je ne leur pardonnerai jamais!", german="Das vergesse ich diesen\nHalunken nie!", italian=" Come hanno potuto!", spanish="¡Nunca perdonaré a esos\ncanallas!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- message_FacePositionOffset(1, 0) [neutre/état moteur]
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="They certainly are quick when\nit comes to...skedaddling.", french="Il est vrai qu'ils sont très\nvéloces lorsqu'il s'agit de... prendre\nla poudre d'escampette.", german="Sie sind schnell, wenn es darum\ngeht, sich aus dem Staub zu machen.", italian="Quei figuri sono certo bravi,\nquando si tratta... di squagliarsela!", spanish="Se les da muy bien eso de\nsalir pitando..."})
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I'm afraid our effort would be\nwasted if we were to give chase now.", french="Je crains qu'il ne soit trop tard\npour nous lancer à leur poursuite.", german="Ich fürchte, wir vergeuden\nnur unsere Energie, wenn wir sie jetzt noch\nverfolgen würden.", italian="Temo che sarebbe inutile\nmettersi al loro inseguimento, adesso.", spanish="Me temo que sería inútil\nintentar perseguirles ahora."})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GROUND:EntTurn(npc_npc_yonowaaru, Direction.Up)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GROUND:EntTurn(partner, Direction.UpRight)
  do local __slot = SkySceneKit.team_member(1); if __slot then GROUND:EntTurn(__slot, Direction.UpRight) end end
  do local __slot = SkySceneKit.team_member(2); if __slot then GROUND:EntTurn(__slot, Direction.UpRight) end end
  GROUND:EntTurn(hero, Direction.UpLeft)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_yonowaaru) end)
  SkySceneKit.say({english="I think we should deliver the\n[CS:Z]Water Float[CR] to the young brothers.", french="Occupons-nous plutôt de\nrestituer l'[CS:Z]Hydroflotteur[CR] aux jeunes frères.", german="Ich finde, wir sollten den\nBrüdern jetzt ihren [CS:Z]Schwimmreif[CR]\nzurückbringen.", italian="Penso che dovremmo consegnare\nl'[CS:Z]Acquaboa[CR] ai legittimi proprietari.", spanish="Será mejor que llevemos\nel [CS:Z]Flotarill[CR] a los dos hermanos."})
  -- message_Close
  GAME:FadeOut(false, 90)
  GAME:WaitFrames(30)
  -- switch(message_Menu(MENU_DUNGEON_TEAM_RETURNS_FROM_MAP)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[8] = 1 -- $SCENARIO_MAIN_BIT_FLAG[8] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.COMPULSORY_SAVE_POINT = 10 -- $COMPULSORY_SAVE_POINT = 10 (ROM)
  -- CallCommon CORO_HANYOU_SAVE_FUNC (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
