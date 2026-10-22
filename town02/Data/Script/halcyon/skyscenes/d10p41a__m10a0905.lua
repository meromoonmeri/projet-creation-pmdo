-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D10P41A/m10a0905.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  SkyProg.set(11, 5) -- $SCENARIO_MAIN = scn[11,5] (ROM)
  -- back_SetGround(LEVEL_D10P41A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Steam Cave.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker("Corphish", true, "corphish", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_HEIGANI) voix hors champ (espèce ROM)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="What if you were to face\n[CS:N]Groudon[CR] in battle?", french="Et si jamais on devait combattre\n[CS:N]Groudon[CR]?", german="Was, wenn man gegen [CS:N]Groudon[CR]\nkämpfen müsste?", italian="Ma che faresti se dovessi\nlottare contro questo [CS:N]Groudon[CR]?", spanish="¿Qué pasaría si alguien se\nenfrentara con [CS:N]Groudon[CR]?"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" What would happen?", french=" Qu'est-ce qui se passerait?", german=" Was würde dann passieren?", italian=" Che succederebbe?", spanish=" Dime, ¿qué pasaría?"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker("Chatot", true, "chatot", 0, '', RogueEssence.Data.Gender.Unknown) end) -- message_SetActor(ACTOR_NPC_PERAPPU) voix hors champ (espèce ROM)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Battle?! Out of the question![K]\nSquawk!", french="Le combattre?! Hors de\nquestion![K] Couac!", german="Kämpfen?!? Völlig unmöglich![K]\nKreisch!", italian="Lottare? È impensabile![K]\nSquack!", spanish=" ¡Eso ni se plantea![K] ¡Cruac, cruac!"})
  -- GAP: se_Play(5122) — id SE NDS sans portage PMDO identifié
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="If anyone were foolish enough to\nface [CS:N]Groudon[CR] in a battle...", french="Il faudrait être fou pour\ns'attaquer à [CS:N]Groudon[CR]...", german="Wenn irgendwer dumm genug\nwäre, [CS:N]Groudon[CR] zum Kampf herauszufordern...", italian="Mettiamo che qualcuno voglia\nprovare a sfidare [CS:N]Groudon[CR]...", spanish="Si alguien fuera lo bastante\nestúpido como para enfrentarse a [CS:N]Groudon[CR]..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Well, it would be like throwing\nyour life away!", french="Ce serait du suicide, ni plus\nni moins!", german="Tja, dazu müsste man\nlebensmüde sein!", italian="Quel folle farebbe bene a\nripensarci!", spanish="¡Acabaría aplastado como una\nmosca!"})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="He is that strong![K] Like all\nlegendary Pokémon!", french="Il est bien trop fort![K] Comme\ntous les Pokémon légendaires!", german="Es ist unglaublich stark![K]\nWie alle legendären Pokémon!", italian="Si tratta di un essere\npotentissimo![K] Come tutti i Pokémon\nleggendari!", spanish="¡Es increíblemente fuerte![K]\n¡Como todos los Pokémon legendarios!"})
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  local npc_npc_guraadon = SkySceneKit.spawn_npc("groudon", 328, 168, Direction.Down, "NPC_GURAADON")
  do local p=npc_npc_guraadon.Position; GROUND:MoveToPosition(npc_npc_guraadon, p.X+(0), p.Y+(12), false, 1) end
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(15)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(15)
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '3', '0')
  GAME:WaitFrames(15)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(2) -- join WaitExecuteLives
  GAME:WaitFrames(45)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  -- ExecuteCommon(CORO_JUMP_SURPRISE_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 2, 30)) end) -- camera_SetEffect('2', '1', '1', '0')
  -- GAP: se_Play(6930) — id SE NDS sans portage PMDO identifié
  -- SetAnimation(9) [anim idle native]
  pcall(function() UI:SetSpeaker(npc_npc_guraadon) end)
  SkySceneKit.say({english=" GRROOOOOOH!", french=" GRROOOOOOH!", german=" GRR...GRR...OOOOOOOOOH!", italian=" GRR... GRR... OOOOOOOOOH!", spanish=" ¡GRRRRRRRR!"})
  GAME:WaitFrames(2) -- join WaitSe
  -- message_CloseEnforce
  -- camera_SetEffect(0): arrêt d'effet caméra
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharSetEmote(partner, "sweating", 1) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Urk... Scary stuff!", french=" Argh... j'ai peur!", german=" Urk... Echt unheimlich!", italian=" Mmm... Brutta storia!", spanish=" ¡Ay, qué miedo!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Urk... This is scary...", french=" Argh... j'ai peur!", german=" Urk... Das ist unheimlich...", italian=" Oh oh! Siamo nei guai!", spanish=" ¡Ay, qué miedo!"})
  else
  SkySceneKit.say({english=" Urk... I'm scared!", french=" Argh... j'ai peur!", german=" Urk... Ich habe Angst!", italian=" Aah... Ho paura!", spanish=" ¡Ay, estoy asustada!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  GAME:WaitFrames(20)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" But we gotta be brave!", french="Mais nous devons faire preuve\nde courage!", german=" Aber wir müssen mutig sein!", italian="Ma non dobbiamo farci\nintimorire!", spanish=" ¡Pero debemos ser valientes!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" But we need to be brave!", french="Mais nous devons faire preuve\nde courage!", german=" Aber wir müssen mutig sein!", italian="Però è proprio questo il\nmomento in cui bisogna tirare fuori il coraggio!", spanish=" ¡Pero debemos ser valientes!"})
  else
  SkySceneKit.say({english=" But it's time to be brave!", french="Mais nous devons faire preuve\nde courage!", german="Aber es ist Zeit, all unseren Mut\nzusammenzunehmen!", italian=" Ma devo essere forte!", spanish=" ¡Pero debemos ser valientes!"})
  end
  -- ExecuteCommon(CORO_JUMP_HAPPY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Shock") end)
  -- ExecuteCommon(CORO_JUMP_ANGRY_FUNC_SERIES, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" And I gotta face up to this!", french=" Et je dois faire face!", german="Ich muss mich dieser Sache\nstellen!", italian=" Possiamo farcela!", spanish=" ¡Tengo que sobreponerme!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" And I need to face up to this!", french=" Et je dois faire face!", german="Ich muss mich dieser Sache\nstellen!", italian=" Dobbiamo affrontarlo!", spanish=" ¡Tengo que sobreponerme!"})
  else
  SkySceneKit.say({english=" And I need to stand up to this!", french=" Et je dois faire face!", german="Ich muss mich dieser Sache\nstellen!", italian="Posso farcela! Possiamo\nfarcela!", spanish=" ¡Tengo que sobreponerme!"})
  end
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" No stopping now, [hero]!", french="Hors de question de baisser\nles bras maintenant, [hero]!", german="Es gibt jetzt kein Zurück,\n[hero]!", italian="Da qui non si torna indietro,\n[hero]!", spanish="¡No podemos rendirnos ahora,\n[hero]!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="There's no giving up now,\n[hero]!", french="Hors de question de baisser\nles bras maintenant, [hero]!", german="Wir können jetzt nicht aufgeben,\n[hero]!", italian="[hero]! Non possiamo\narrenderci proprio ora!", spanish="¡Ahora no podemos volvernos\natrás, [hero]!"})
  else
  SkySceneKit.say({english="We can't just run away now,\n[hero]!", french="Hors de question de baisser\nles bras maintenant, [hero]!", german="Wir können jetzt nicht\nweglaufen, [hero]!", italian="Insieme ce la possiamo fare,\n[hero]!", spanish="¡No podemos salir corriendo,\n[hero]!"})
  end
  -- CallCommon CORO_MESSAGE_CLOSE_WAIT_FUNC (fermeture/attente message: géré par say())
  pcall(function() UI:SetSpeaker(npc_npc_guraadon) end)
  SkySceneKit.say({english="PREPARE FOR MY WRATH!\nGRROOOOOOH!", french="PREPAREZ-VOUS A SUBIR\nMON COURROUX! GRROOOOOOH!", german="MACHT EUCH AUF MEINEN ZORN\nGEFASST! GRROOOOOOH!", italian="PREPARATEVI AD ASSAGGIARE\nLA MIA IRA!", spanish="¡PREPARAOS PARA SUFRIR\nMI CÓLERA! ¡GRRRRRRRR!"})
  -- SetAnimation(19) [anim idle native]
  GAME:WaitFrames(2) -- join WaitAnimation
  GAME:WaitFrames(15)
  -- GAP: se_Play(6914) — id SE NDS sans portage PMDO identifié
  pcall(function() GROUND:MoveScreen(RogueEssence.Content.ScreenMover(0, 4, 30)) end) -- camera_SetEffect('2', '2', '2', '0')
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(3) [anim idle native]
  -- MoveHeight(2, 5) [élévation d'objet NDS non simulée - documenté]
  -- MoveHeight(2, 5) [élévation d'objet NDS non simulée - documenté]
  GAME:WaitFrames(1)
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  -- MoveHeight(2, 0) [élévation d'objet NDS non simulée - documenté]
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  GAME:WaitFrames(15)
  -- camera_SetEffect(0): arrêt d'effet caméra
  GAME:WaitFrames(2) -- join WaitSe
  -- message_Close
  pcall(function() SOUND:FadeOutBGM(10) end)
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
  -- CallCommon CORO_BOSS_WIPE_FUNC (fermeture/attente message: géré par say())
  -- main_EnterDungeon(16, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- main_EnterDungeon(-1, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  SkySceneKit.cleanup_npcs()
end
